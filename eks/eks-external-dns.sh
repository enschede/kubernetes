#!/bin/bash

helm upgrade --install extdns bitnami/external-dns \
--set provider=aws \
--set interval=1m \
--set logLevel=debug \
--set policy=sync \

#--set aws.prefer=CNAME \
#--set domainFilters[0]=*.liberaalgeluid.nl \
#--set registry=txt \
#--set txtOwnerId=Z00691841HMBHE5SI77D0 \
#--set rbac.create=true \
#--set aws.zoneType=public \
#--set rbac.serviceAccountName=external-dns \
#--set rbac.serviceAccountAnnotations.eks\.amazonaws\.com/role-arn=arn:aws:iam::228991124303:policy/route53-ingress