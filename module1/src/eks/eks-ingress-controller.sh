#!/bin/bash

CLUSTER_NAME=enschede

helm install incubator/aws-alb-ingress-controller \
  --set clusterName=$CLUSTER_NAME \
  --set autoDiscoverAwsRegion=true \
  --set autoDiscoverAwsVpcID=true
