# Ingress op Kubernetes

### Ingress op Docker Desktop

Installeren van de Ingress op Docker Desktop

    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.34.1/deploy/static/provider/cloud/deploy.yaml
    
De installatie duurt enige tijd. Wacht dit af met dit script

    kubectl wait --namespace ingress-nginx \
      --for=condition=ready pod \
      --selector=app.kubernetes.io/component=controller \
      --timeout=120s

Dan de ingress definiëren

    apiVersion: networking.k8s.io/v1beta1
    kind: Ingress
    metadata:
      name: module1-ingress
      annotations:
        nginx.ingress.kubernetes.io/ssl-redirect: "false"
        nginx.ingress.kubernetes.io/rewrite-target: /$2
    spec:
      rules:
        - http:
            paths:
              - path: /module1(/|$)(.*)
                backend:
                  serviceName: module1-nodeport
                  servicePort: 8080


