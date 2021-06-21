#!/bin/bash

eksctl create cluster -f enschede.yaml

echo =====> EKS Cluster admin toevoegen
./eks-cluster-admin.sh

echo =====> EKS Cluster autoscaler
./eks-cluster-autoscaler.sh

echo =====> EKS Cluster logging
./eks-logging.sh

echo =====> EKS Helm
./eks-helm.sh

echo =====> EKS Dashboard
./eks-dashboard.sh

echo =====> EKS Ingress Controller
./eks-ingress-controller.sh

echo =====> EKS External DNS
./eks-external-dns.sh

./eks-dashboard-proxy.sh
