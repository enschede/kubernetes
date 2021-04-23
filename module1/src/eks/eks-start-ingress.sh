#!/bin/bash

eksctl create cluster -f enschede.yaml

# Voeg iam user eks-cluster-admin toe aan system:masters
eksctl create iamidentitymapping --cluster enschede --arn arn:aws:iam::228991124303:user/eks-cluster-admin --username eks-cluster-admin --group system:masters
kubectl -n kube-system get cm aws-auth -o yaml
# Voeg iam user toe aan ~/.kube/config file
eksctl utils write-kubeconfig --cluster enschede --profile eks-cluster-admin
# Set iam user als default user
kubectl config use-context eks-cluster-admin@enschede.us-west-2.eksctl.io

#eksctl utils update-cluster-logging --region=us-west-2 --cluster=enschede

./eks-logging.sh
./eks-helm.sh
./eks-dashboard.sh
./eks-ingress-controller.sh
