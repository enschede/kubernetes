## Kubernetes services

### Command

    kubectl get svc
    kubectl expose deployment module1 --type=ClusterIP --port=8080
    kubectl expose deployment module1 --type=NodePort --port=8080
    kubectl expose deployment module1 --type=LoadBalancer --port=8080

    kubectl get ingress
    kubectl get ing

### ClusterIP
ClusterIP creates a service that is accesseble within the cluster

    apiVersion: v1
    kind: Service
    metadata:
      labels:
        app: module1
      name: module1
    spec:
      ports:
        - port: 8080
          protocol: TCP
          targetPort: 8080
      selector:
        app: module1
      sessionAffinity: None
      type: ClusterIP

### Multi port

    spec:
      ports:
        - name: http
          port: 8080
          protocol: TCP
          targetPort: 8080
        - name: special
          port: 8081
          protocol: TCP
          targetPort: special

### Nodeport
Nodeport creates a service that is accesseble outside the cluster using a (random) port

    apiVersion: v1
    kind: Service
    metadata:
      labels:
        app: module1
      name: module1-nodeport
      namespace: default
    spec:
      ports:
        - port: 8080
          protocol: TCP
          targetPort: 8080
      selector:
        app: module1
      sessionAffinity: None
      type: NodePort

Use a predefined port

      ports:
        - nodePort: 30286
          port: 8080
          protocol: TCP
          targetPort: 8080

### LoadBalancer

    apiVersion: v1
    kind: Service
    metadata:
      labels:
        app: module1
      name: module1-lb
      namespace: default
    spec:
      ports:
        - port: 8080
          protocol: TCP
          targetPort: 8080
      selector:
        app: module1
      sessionAffinity: None
      type: LoadBalancer

### Ingress
To be tested

    apiVersion: networking.k8s.io/v1beta1
    kind: Ingress
    metadata:
      name: module1-ingress
      annotations:
        nginx.ingress.kubernetes.io/rewrite-target: /
      labels:
        app: module1
    spec:
      rules:
        - http:
            paths:
              - path: /testpath/*
    #            pathType: Prefix
                backend:
                  serviceName: module1
                  servicePort: 8080


### Docker Desktop
On Docker Desktop
- the LoadBalancer type seems not to be functional
- the Ingress type seems not to be functional

