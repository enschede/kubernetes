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
See [Ingress](ingress.md)

### Docker Desktop
On Docker Desktop
- the LoadBalancer type seems not to be functional (other than NodePort)
- the Ingress should be loaded. See [Ingres](ingress.md)

### AWS EKS
On EKS
- the NodePort seems not to be functionel (other than ClusterIP), both do not expose a port
- the LoadBalancer initiates an load balancer to be spinned up (one for each service)

## Service discovery and DNS naming

- postgres-postgresql.default.svc.cluster.local
    - postgres-postgresql is servicename
    - default is namespace
    - svc.cluster.local verwijst naar service
- postgres-postgresql
    - verwijst naar service in eigen namespace


The caller service then need only refer to names resolvable in a particular Kubernetes cluster. A simple implementation might use a spring RestTemplate that refers to a fully qualified domain name (FQDN), such as 

    {service-name}.{namespace}.svc.{cluster}.local:{service-port}

https://docs.spring.io/spring-cloud-kubernetes/docs/1.1.5.RELEASE/reference/html/
