#!/bin/bash

cat <<EOF | eksctl create cluster -f -
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig
metadata:
  name: enschede
  region: us-west-2
  version: "1.19"
vpc:
  autoAllocateIPV6: true     # Doet niks
#nodeGroups:
managedNodeGroups:
  - name: ng-1
#    labels: { role: web }
    instanceType: t3.medium
    desiredCapacity: 1
    minSize: 1
    maxSize: 4
#    asgMetricsCollection:
#      - granularity: 1Minute
#        metrics:
#          - GroupMinSize
#          - GroupMaxSize
#          - GroupDesiredCapacity
#          - GroupInServiceInstances
#          - GroupPendingInstances
#          - GroupStandbyInstances
#          - GroupTerminatingInstances
#          - GroupTotalInstances
#    ssh:
#      allow: true
    iam:
      # polices added to worker node role
      withAddonPolicies:
        imageBuilder: true      # ecr access
        autoScaler: true
        externalDNS: true       # allows read/write to zones in Route53
        certManager: true
        appMesh: true
        appMeshPreview: true
        ebs: true
        fsx: true
        efs: true
        albIngress: true        # required for ALB-ingress
        xRay: true
        cloudWatch: true
fargateProfiles:
  - name: fp-dev
    selectors:
      # All workloads in the "dev" Kubernetes namespace matching the following
      # label selectors will be scheduled onto Fargate:
      - namespace: dev
        labels:
          env: dev
          checks: passed
cloudWatch:
  clusterLogging:
    enableTypes: ["*"]
EOF

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
