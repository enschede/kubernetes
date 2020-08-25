# Kubernetes test project

## Docker commands

    docker container ls -a
    docker container ls
    docker image ls
    

## Kubernetes deployment

    kubectl create deployment module1 --image=enschede/kubernetes-module1:0.0.1-SNAPSHOT
    kubectl logs deployment/module1
    kubectl get pods
    kubectl get all
    kubectl get deployment/module1 -o yaml >deployment.yaml   
    kubectl delete deployment/module1
    
    kubectl get svc
    kubectl expose deployment ozon-loader --type=LoadBalancer --port=8080
    kubectl get deployment/ozon-loader -o yaml >deploy.yaml
    kubectl apply -f deploy.yaml -f service.yaml

## Helm

    helm init
    
