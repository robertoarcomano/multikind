#!/bin/bash
kubectl delete -f cassandra-statefulset.yaml
kubectl delete pvc --all 
kubectl delete pv --all 
kubectl create -f cassandra-statefulset.yaml
sleep 120
TARGET_REPLICA=6
for i in `seq 2 $TARGET_REPLICA`; do 
    kubectl scale statefulset cassandra --replicas=$i
    sleep 90;
done