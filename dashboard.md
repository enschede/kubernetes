# Kubernetes Dashboard

## Docker Desktop

    helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
    helm install kubernetes-dashboard/kubernetes-dashboard --name dashboard --set protocolHttp=true

## AWS EKS

    export DASHBOARD_VERSION="v2.0.0"    
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/${DASHBOARD_VERSION}/aio/deploy/recommended.yaml

    kubectl proxy --port=8001 --address=0.0.0.0 --disable-filter=true &

### Opvragen token

    kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep eks-admin | awk '{print $1}')

### Link

http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#!/login
    
### Bron
    
    https://www.eksworkshop.com/beginner/040_dashboard/dashboard/

