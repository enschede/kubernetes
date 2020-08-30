#!/bin/bash

kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep eks-admin | awk '{print $1}')
kubectl proxy --port=8001 --address=0.0.0.0 --disable-filter=true
