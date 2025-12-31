module "ssh_server" {
  source = "./modules/ssh_server"
  count = var.enable_ssh_server ? 1 : 0
  replicas = var.replicas
}

module "mariadb" {
  source = "./modules/mariadb"
  count = var.enable_mariadb ? 1 : 0
  mariadb_replicas = var.mariadb_replicas
}

module "pod" {
  source = "./modules/pod"
  count = var.enable_pod ? 1 : 0
}

module "cassandra" {
  source = "./modules/cassandra"
  count = var.enable_cassandra ? 1 : 0
  cassandra_replicas = var.cassandra_replicas
}

module "k8ssandra_cluster" {
  source = "./modules/k8ssandra_cluster"
  count = var.enable_k8ssandra_cluster ? 1 : 0
  k8ssandra_replicas = var.k8ssandra_replicas
  depends_on = [
    module.k8ssandra_operator
  ]  
}

module "k8ssandra_operator" {
  source = "./modules/k8ssandra_operator"
  count = var.enable_k8ssandra_operator ? 1 : 0
}
