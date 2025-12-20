# Multikind
Multi-project on kind tutorial - k8s

## Install and test kind
### 1. Install kind
```
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.24.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/bin
```
### 2. Create cluster
```
kind create cluster --name lap --config kind-config.yaml
```
### 3. Create shortcut for kubectl and auto completion
```
kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null
source /etc/bash_completion.d/kubectl
echo 'source <(kubectl completion bash | sed "s/kubectl/k/g")' >> ~/.bashrc
source ~/.bashrc
```
### 4. Test cluster
```
kubectl cluster-info
kubectl get nodes
kubectl get pods -A
```

## Install Helm and cert-manager
```
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
rm ./get_helm.sh
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.15.3/cert-manager.yaml
k get pods -n cert-manager
```

## Install Cassandra
### 1. Add k8ssandra helm repo
```
helm repo add k8ssandra https://helm.k8ssandra.io/stable
helm repo update
```
### 2. Install k8ssandra operator
```
helm install k8ssandra-operator k8ssandra/k8ssandra-operator \
  --namespace k8ssandra-operator \
  --create-namespace
```
### 3. Create Cassandra Cluster(3 nodes)
```
cat <<EOF | k apply -f -
apiVersion: k8ssandra.io/v1alpha1
kind: K8ssandraCluster
metadata:
  name: cassandra-cluster
spec:
  cassandra:
    storageConfig:
      cassandraDataVolumeClaimSpec:
        storageClassName: null
        accessModes:
          - ReadWriteOnce
        resources:
          requests:
            storage: 5Gi
    datacenters:
      - metadata:
          name: dc1
        size: 2
EOF
```


# Alternative
## Install Cassandra
### 1. Add bitnami repo
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
### 2. Install Cassandra helm operator
```
helm install cassandra bitnami/cassandra --set replicaCount=3
```    
### 3. Check Cassandra pods

### 4. Get the password
```
export CASSANDRA_PASSWORD=$(kubectl get secret --namespace "default" cassandra -o jsonpath="{.data.cassandra-password}" | base64 -d)
```