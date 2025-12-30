#!/bin/bash

# cert-manager
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --set installCRDs=true

# k8ssandra operator
helm repo add k8ssandra https://helm.k8ssandra.io/stable
helm repo update
helm install k8ssandra-operator k8ssandra/k8ssandra-operator -n k8ssandra-operator --set global.clusterScoped=true --create-namespace
sleep 60

# Create the k8ssandra cluster
kubectl create -f k8c1.yaml
