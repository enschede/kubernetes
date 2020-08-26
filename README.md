# Kubernetes test project

- [Service](service.md)
- [ConfigAndSecrets](configAndSecrets.md)
- [Persistent volumes](volumes.md)
- [DnsAndServiceDiscovery](serviceDiscovery.md)
- [Helm](helm.md)
- [Usefull Docker commands](docker.md)

# Todo

- SB Cloud Kubernetes  
- Deploy op AWS
- LoadBalancer vs NodePort op AWS
- Ingress op AWS
    - verwijzen naar named port
- EBS op AWS
- Logging op AWS

## Kubernetes deployment

    kubectl create deployment module1 --image=enschede/kubernetes-module1:0.0.1-SNAPSHOT
    kubectl get pods
    kubectl get all
    kubectl get deployment/module1   
    kubectl get deployment/module1 --watch  
    kubectl get deployment/module1 -o yaml >deployment.yaml   
    kubectl delete deployment/module1
    kubectl apply -f deployment.yaml -f service.yaml
    
    kubectl delete all -l app=module1
    kubectl delete service -l app=module1
    
## Kubernetes logging

    kubectl logs deployment/module1
    kubectl logs -f deployment/module1

## Helm

    helm init
    
