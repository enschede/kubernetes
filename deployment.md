## Kubernetes deployment

## Command

    kubectl create deployment module1 --image=enschede/kubernetes-module1:0.0.1-SNAPSHOT
    kubectl api-resources
    kubectl get pods
    kubectl get pods -o wide
    kubectl get pods -o yaml
    kubectl get all
    kubectl get deployment/module1   
    kubectl get deployment/module1 --watch  
    kubectl get deployment/module1 -o yaml >deployment.yaml
    kubectl delete deployment/module1
    kubectl apply -f deployment.yaml -f service.yaml
    kubectl rolling-update demo1rpi --image=enschede/demo1rpi:3
    kubectl label nodes <node-name> <label-key>=<label-value>
        
    kubectl delete all -l app=module1
    kubectl delete service -l app=module1

### Logging
    
    kubectl logs deployment/module1
    kubectl logs -f deployment/module1
    
Logging on EKS, see [EKS](eks.md)

### Scaling

See https://thefuturegroup.udemy.com/course/kubernetes-crash-course-for-java-developers/learn/lecture/16905670#overview

    kubectl scale --replicas=1 deployment/module1
    kubectl scale deployment module1 --replicas=2

## Desployment descriptor

    apiVersion: apps/v1
    kind: Deployment
    metadata:
      annotations:
        deployment.kubernetes.io/revision: "1"
      labels:
        app: module1
      name: module1
    spec:
      progressDeadlineSeconds: 600
      replicas: 1
      revisionHistoryLimit: 10
      selector:
        matchLabels:
          app: module1
      strategy:
        rollingUpdate:
          maxSurge: 25%
          maxUnavailable: 25%
        type: RollingUpdate
      template:
        metadata:
          labels:
            app: module1
        spec:
          containers:
          - image: enschede/kubernetes-module1:0.0.12-SNAPSHOT
            env: {}
              # Zie configAndSecrets
            imagePullPolicy: Always
            name: kubernetes-module1
            terminationMessagePath: /dev/termination-log
            terminationMessagePolicy: File
          dnsPolicy: ClusterFirst
          restartPolicy: Always
          schedulerName: default-scheduler
          securityContext: {}
          terminationGracePeriodSeconds: 30

### Resources

          containers:
          - image: enschede/kubernetes-module1:0.0.12-SNAPSHOT
            resources:
              requests:
                # cpu: 200m
                memory: 512Mi
              limits:
                # cpu 400m
                memory: 1024Mi

### Readiness probe
Wordt gebruikt door replica set om te bepalen of pod healthy is

          containers:
          - image: enschede/kubernetes-module1:0.0.12-SNAPSHOT
            readinessProbe:
              httpGet:
                port: 8080
                path: /actuator/health
              failureThreshold: 5
              periodSeconds: 10
              initialDelaySeconds: 60

### Liveness probe
Wordt gebruikt door load balancer om te bepalen of pod ready is

          containers:
          - image: enschede/kubernetes-module1:0.0.12-SNAPSHOT
            livenessProbe:
              httpGet:
                port: 8080
                path: /actuator/health
              failureThreshold: 5
              periodSeconds: 10
              initialDelaySeconds: 60
