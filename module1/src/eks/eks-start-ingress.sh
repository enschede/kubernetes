#!/bin/bash

eksctl create cluster -f enschede.yaml

echo =====> EKS Cluster admin toevoegen
# Voeg iam user eks-cluster-admin toe aan system:masters
eksctl create iamidentitymapping --cluster enschede --arn arn:aws:iam::228991124303:user/eks-cluster-admin --username eks-cluster-admin --group system:masters
kubectl -n kube-system get cm aws-auth -o yaml
# Voeg iam user toe aan ~/.kube/config file
eksctl utils write-kubeconfig --cluster enschede --profile eks-cluster-admin
# Set iam user als default user
kubectl config use-context eks-cluster-admin@enschede.us-west-2.eksctl.io

#eksctl utils update-cluster-logging --region=us-west-2 --cluster=enschede

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
