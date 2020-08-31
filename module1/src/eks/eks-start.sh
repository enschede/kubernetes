#!/bin/bash

cat <<EOF | eksctl create cluster -f -
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig
metadata:
  name: enschede
  region: us-west-2
nodeGroups:
  - name: ng-1
    instanceType: t3.medium
    desiredCapacity: 2
    minSize: 1
    maxSize: 4
    iam:
      # polices added to worker node role
      withAddonPolicies:
        # ecr access
        imageBuilder: true
        autoScaler: true
        # allows read/write to zones in Route53
        externalDNS: true
        certManager: true
        appMesh: true
        appMeshPreview: true
        ebs: true
        fsx: true
        efs: true
        # required for ALB-ingress
        albIngress: true
        xRay: true
        cloudWatch: true
cloudWatch:
  clusterLogging:
    enableTypes: ["*"]
EOF

#eksctl utils update-cluster-logging --region=us-west-2 --cluster=enschede

./logging.sh
./eks-helm.sh
./eks-dashboard.sh
./eks-ingress.sh
