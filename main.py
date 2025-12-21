import uuid
import time
from cassandra.cluster import Cluster, ExecutionProfile, EXEC_PROFILE_DEFAULT
from cassandra.query import BatchStatement, BatchType
from concurrent.futures import ThreadPoolExecutor
from functools import wraps
from cassandra.concurrent import execute_concurrent
from cassandra.policies import TokenAwarePolicy, DCAwareRoundRobinPolicy
import multiprocessing as mp


class Cassandra:
    def get_profile(self):
        return ExecutionProfile(
            load_balancing_policy=TokenAwarePolicy(DCAwareRoundRobinPolicy()),
            request_timeout=30,
        )

    def __init__(self, key_space):
        self.host = '172.22.0.4'
        self.port = 30983
        self.cluster = Cluster([self.host], port=self.port, execution_profiles={EXEC_PROFILE_DEFAULT: self.get_profile()}, max_schema_agreement_wait=10)
        self.session = self.cluster.connect()
        self.session.execute(f"""
            CREATE KEYSPACE IF NOT EXISTS {key_space} 
            WITH replication = {{'class': 'SimpleStrategy', 'replication_factor': 1}}
        """)
        self.session = self.cluster.connect(key_space)
        self.create_users_table()

    def create_users_table(self):
        self.session.execute("""
            CREATE TABLE IF NOT EXISTS users (
                id UUID PRIMARY KEY, 
                name TEXT, 
                email TEXT
            )
        """)

    @staticmethod
    def _worker_process(key_space, start_index, count, concurrency, users):
        cass = Cassandra(key_space=key_space)
        partial_users = [(f"{users[i][0]}", f"{users[i][1]}")
                 for i in range(start_index, start_index + count)]
        cass.speed_concurrent_insert(partial_users, len(partial_users),concurrency=concurrency)

    def measure_speed(num_arg_name="num_records", label="Speed"):
        def decorator(func):
            @wraps(func)
            def wrapper(*args, **kwargs):
                # Recupera num_records da kwargs o args
                import inspect
                sig = inspect.signature(func)
                bound = sig.bind(*args, **kwargs)
                bound.apply_defaults()
                num_records = bound.arguments[num_arg_name]

                start = time.time()
                result = func(*args, **kwargs)
                stop = time.time()
                elapsed = stop - start or 1e-9
                print(f"{label}: {round(num_records / elapsed, 2)} records/s")
                return result
            return wrapper
        return decorator

    @classmethod
    @measure_speed(num_arg_name="total_records", label="multiprocess_concurrent_insert")
    def multiprocess_insert(cls, key_space, total_records, n_processes=4, concurrency=256):
        per_proc = total_records // n_processes
        procs = []
        users = cls.generate_users(total_records)
        for p in range(n_processes):
            start_idx = p * per_proc
            count = per_proc if p < n_processes - 1 else (total_records - per_proc * (n_processes - 1))

            proc = mp.Process(
                target=cls._worker_process,
                args=(key_space, start_idx, count, concurrency, users)
            )
            proc.start()
            procs.append(proc)

        for proc in procs:
            proc.join()


    def insert_user(self, name, email):
        self.session.execute(
            "INSERT INTO users (id, name, email) VALUES (%s, %s, %s)",
            (uuid.uuid4(), name, email)
        )

    def multi_batch_insert(self, users):
        chunk_size = 100
        prepared = self.session.prepare(
            "INSERT INTO users (id, name, email) VALUES (uuid(), ?, ?)"
        )
        
        batch = BatchStatement(BatchType.UNLOGGED)
        batch_count = 0
        
        for user in users:  
            batch.add(prepared, user)
            batch_count += 1
            
            if batch_count >= chunk_size:
                self.session.execute(batch)
                batch.clear()
                batch_count = 0
        
        if batch_count > 0:
            self.session.execute(batch)

    def __del__(self):
        self.cluster.shutdown()

    def select_all(self):
        rows = self.session.execute("SELECT * FROM users")
        for row in rows:
            print(row)

    def delete_all(self):
        self.session.execute("TRUNCATE users")  

    @classmethod
    def generate_users_yield(cls, n):
        for i in range(n):
            name = f"User {i}"
            email = f"user{i}@example.com"
            yield (name, email)

    @classmethod
    def generate_users(cls, n):
        return list(cls.generate_users_yield(n))

    @measure_speed(num_arg_name="num_records", label="multi_batch_insert")
    def speed_multi_batch_insert(self, num_records):
        users = self.generate_users_yield(num_records)        
        self.multi_batch_insert(users)

    @measure_speed(num_arg_name="num_records", label="concurrent_insert")
    def single_speed_concurrent_insert(self, num_records):
        users = self.generate_users(num_records)
        self.speed_concurrent_insert(users, num_records)

    def speed_concurrent_insert(self, records, num_records, concurrency=512):
        # Prepara TUTTI gli statement in anticipo
        statements = []
        prepared = self.session.prepare(
            "INSERT INTO users (id, name, email) VALUES (uuid(), ?, ?)"
        )
        
        for user in records:
            statements.append((prepared, user))
        
        results = execute_concurrent(
            self.session, 
            statements, 
            concurrency=concurrency,  
            raise_on_first_error=False
        )

key_space = 'cassandra_data'
num_records = 1000000
cassandra = Cassandra(key_space=key_space)
cassandra.delete_all()

# cassandra.speed_multi_batch_insert(num_records)
# cassandra.single_speed_concurrent_insert(num_records)
Cassandra.multiprocess_insert(
    key_space=key_space,
    total_records=num_records,
    n_processes=100,     
    concurrency=512    
)
