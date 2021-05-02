# Helm

## Voorbereiden Helm

### Docker Desktop

    helm init

### AWS EKS

    kubectl create serviceaccount --namespace kube-system tiller
    kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
    kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'
    helm init

Bron: https://github.com/fnproject/fn-helm/issues/21

## Install met Helm

    helm create module1
    
    helm install --name module1 .
    helm ls
    helm list
    
    helm upgrade module1 .
    helm history module1
    
    helm delete module1
    helm delete --purge module1

## Helm 3

helm install module1 . helm install module2 . -n module2 helm update module1 . helm delete module2 =n module2

helm install prometheus prometheus-community/prometheus

