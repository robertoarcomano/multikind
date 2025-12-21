#!/bin/bash
kubectl delete -f cassandra-statefulset.yaml
kubectl create -f cassandra-statefulset.yaml
sleep 60
kubectl scale statefulset cassandra --replicas=3
