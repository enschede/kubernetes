#!/bin/bash

cat <<EOF | eksctl create cluster -f -
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig
metadata:
  name: enschede
  region: us-west-2
#  version: "1.17"
#vpc:
#  autoAllocateIPV6: true     # Doet niks
nodeGroups:
# managedNodeGroups:
  - name: ng-1
    instanceType: t3.medium
    desiredCapacity: 2
    minSize: 1
    maxSize: 4
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
#nodeGroups:
#  - name: ng-2
#    instanceType: t3.medium
#    desiredCapacity: 2
#    minSize: 1
#    maxSize: 4
#    ssh:
#      allow: true
#    iam:
#      # polices added to worker node role
#      withAddonPolicies:
#        # ecr access
#        imageBuilder: true
#        autoScaler: true
#        # allows read/write to zones in Route53
#        externalDNS: true
#        certManager: true
#        appMesh: true
#        appMeshPreview: true
#        ebs: true
#        fsx: true
#        efs: true
#        # required for ALB-ingress
#        albIngress: true
#        xRay: true
#        cloudWatch: true
cloudWatch:
  clusterLogging:
    enableTypes: ["*"]
EOF

#eksctl utils update-cluster-logging --region=us-west-2 --cluster=enschede

./eks-logging.sh
./eks-helm.sh
./eks-dashboard.sh
./eks-ingress-controller.sh
