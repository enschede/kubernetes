## Kubernetes services

### Command

    kubectl get svc
    kubectl expose deployment module1 --type=ClusterIP --port=8080
    kubectl expose deployment module1 --type=NodePort --port=8080
    kubectl expose deployment module1 --type=LoadBalancer --port=8080

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

### Docker Desktop
On Docker Desktop, there seems to be no difference using NodePort or LoadBalancer
