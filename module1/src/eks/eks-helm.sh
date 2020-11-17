#!/bin/bash

kubectl create serviceaccount tiller \
  --namespace kube-system
kubectl create clusterrolebinding tiller-admin-binding \
  --clusterrole=cluster-admin \
  --serviceaccount=kube-system:tiller
helm init --service-account=tiller

helm repo update
