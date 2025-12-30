# Multikind
Multi-project on kind tutorial - k8s


<details>
<summary>
<b>Kind</b>
</summary>

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
</details>


<br>
<details>
<summary>
<b>Opentofu</b>
</summary>

### 1. Install Opentofu
```
curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh
chmod +x install-opentofu.sh
./install-opentofu.sh --install-method deb
rm -f install-opentofu.sh
```

### 2. Initialize tofu
```
tofu init -upgrade
```
</details>

<br>
<details>
<summary>
<b>Cassandra</b>
</summary>

### 1. Install Cassandra
```
tofu apply -var "enable_cassandra=true" -var "cassandra_replicas=3" -auto-approve
```

### 2. Test Cassandra
#### 2.1. Install virtual environment
```
python -m venv .venv
source .venv/bin/activate
```
#### 2.2. Install cassandra-driver
```
pip install cassandra-driver
```
#### 2.3. Launch test
```
python cassandra/main.py
```


### 3. Uninstall Cassandra
#### 3.1. Remove StatefulSet/Pods/Services
```
tofu apply -var "enable_cassandra=false" -var "cassandra_replicas=3" -auto-approve
```
#### 3.2. Remove pvc as well
```
kubectl delete pvc -l app=cassandra
```
</details>

<br>

<details>
<summary><b>K8ssandra</b></summary>

### 1. Enter k8ssandra directory
```
cd k8ssandra
```

### 2. Install cert-manager
```
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --set installCRDs=true
```

### 3. Install k8ssandra operator
```
helm repo add k8ssandra https://helm.k8ssandra.io/stable
helm repo update
helm install k8ssandra-operator k8ssandra/k8ssandra-operator -n k8ssandra-operator --set global.clusterScoped=true --create-namespace
sleep 60
kubectl create -f k8c1.yaml
```
</details>

