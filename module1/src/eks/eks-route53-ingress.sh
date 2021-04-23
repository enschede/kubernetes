#!/usr/bin/env bash

AWS_REGION=`eksctl get cluster -o json | jq -r '.[].metadata.region'`
ISSUER_URL=$(aws eks describe-cluster --name enschede --query "cluster.identity.oidc.issuer" --region us-west-2 --output text)
echo $ISSUER_URL

aws iam create-open-id-connect-provider --url ${ISSUER_URL} --thumbprint-list 9e99a48a9960b14926bb7f3b02e22da2b0ab7280 --client-id-list sts.amazonaws.com --region us-west-2
