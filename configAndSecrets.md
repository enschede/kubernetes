## Kubernetes services

## Configuratie invoeren

    kubectl create configMap generic mysecret --from-literal=env3='valueForEnv3FromCommandLine'
    kubectl delete configMap/my-config
    kubectl create secret generic mysecret --from-literal=env3='valueForEnv3FromCommandLine'
    kubectl delete secret/mysecret

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

## Laden via Environment

Environment vars
- env1 hard setting
- env2 via configMap
- env3 via secret


    spec:
      template:
        spec:
          containers:
          - image: enschede/kubernetes-module1:0.0.14-SNAPSHOT
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

## Via Kubernetes

Values in Spring Boot worden geladen middels Kubernetes plug-in. Default is de metadata.name gelijk aan de naam van de applicatie in application.properties.

De values worden op 'watch' gezet, als nieuwe values geladen worden, worden deze ook hot aangepast in de applicatie.

De applicatie moet toegang hebben tot de Kubernetes API. Hiervoor is een role en role binding nodig.

Documentatie:

    - https://spring.io/projects/spring-cloud-kubernetes#overview
    - https://thefuturegroup.udemy.com/course/kubernetes-crash-course-for-java-developers/learn/lecture/16905658#overview (60 t/m 66)
    
Dit moet nog getest worden.