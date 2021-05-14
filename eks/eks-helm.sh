#!/bin/bash

kubectl create serviceaccount tiller --namespace kube-system
kubectl create clusterrolebinding tiller-admin-binding --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account=tiller

# Lijkt nodig indien helm3 service wordt geladen binnen FarGate (niet zeker)
sleep 10

helm repo update
