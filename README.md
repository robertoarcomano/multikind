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

## Install Cassandra
### 1. Add k8ssandra helm repo
```
kubectl create -f cassandra-statefulset.yaml
```
