## Kubernetes services

### Command

    kubectl delete configMap/my-config
    kubectl delete secret/mysecret

### Deployment

Environment vars
- env1 hard setting
- env2 via configMap
- env3 via secret


    spec:
      template:
        spec:
          containers:
          - image: enschede/kubernetes-module1:0.0.5-SNAPSHOT
            env:
              - name: env1
                value: valueForEnv1
              - name: env2
                valueFrom:
                  configMapKeyRef:
                    name: my-config
                    key: myconfig.env2
              - name: env3
                valueFrom:
                  secretKeyRef:
                    name: mysecret
                    key: env3

### ConfigMap

    apiVersion: v1
    kind: ConfigMap
    metadata:
      name: my-config
      labels:
        app: module1
    data:
      myconfig.env2: valueForEnv2

### Secret
Via command line

    kubectl create secret generic mysecret --from-literal=env3='valueForEnv3FromCommandLine'

Via secret file

    echo -n 'valueForEnv3FromFile' | base64
    
Add value to secret file

    apiVersion: v1
    kind: Secret
    metadata:
      name: mysecret
      labels:
        app: module1
    type: Opaque
    data:
      env3: dmFsdWVGb3JFbnYzRnJvbUZpbGU=

### Secrets via file
Nog te testen
