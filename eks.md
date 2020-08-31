# EKS

## EKS inrichten

### Inrichten command line

    eksctl create cluster --name=enschede --name=enschede --nodes-min 2 --nodes-max 5 --asg-access --full-ecr-access --alb-ingress-access --ssh-access
    eksctl create cluster --name=enschede --nodes-min 2 --nodes-max 5 --asg-access --ssh-access

    eksctl utils describe-stacks --region=us-west-2 --cluster=enschede
    eksctl utils update-cluster-logging --region=us-west-2 --cluster=enschede

### Inrichten configuratie file

    cat <<EOF | eksctl create cluster -f -
    apiVersion: eksctl.io/v1alpha5
    kind: ClusterConfig
    metadata:
      name: enschede
      region: us-west-2
    nodeGroups: of managedNodeGroups:
      - name: ng-1
        instanceType: t3.medium
        desiredCapacity: 2
        minSize: 1
        maxSize: 4
        iam:
          # polices added to worker node role
          withAddonPolicies:
            # ecr access
            imageBuilder: true
            autoScaler: true
            # allows read/write to zones in Route53
            externalDNS: true
            certManager: true
            appMesh: true
            appMeshPreview: true
            ebs: true
            fsx: true
            efs: true
            # required for ALB-ingress
            albIngress: true
            xRay: true
            cloudWatch: true
    cloudWatch:
      clusterLogging:
        enableTypes: ["*"]
    EOF
    
    
Een managedNodeGroup wordt beheerd door AWS. Updates en scaling gaan automatisch.
    
Toevoegen van een extra node cluster

      - name: ng-2
        instanceType: m5.large
        desiredCapacity: 2
        minSize: 1
        maxSize: 4
        iam:
          # polices added to worker node role
          withAddonPolicies:
            # allows read/write to zones in Route53
            externalDNS: true
            # required for ALB-ingress
            albIngress: true
            certManager: true
        ssh:
          allow: true


### EKS opruimen

    eksctl delete cluster --name=enschede --wait

## Helm
Inrichten Helm2 op EKS

    kubectl create serviceaccount tiller \
        --namespace kube-system
    kubectl create clusterrolebinding tiller-admin-binding \
        --clusterrole=cluster-admin \
        --serviceaccount=kube-system:tiller
    helm init --service-account=tiller
    helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
    helm repo update

## Dashboard (alt 1, preferred)

    kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml
    
    cat <<EOF | kubectl apply -f -
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: eks-admin
      namespace: kube-system
    ---
    apiVersion: rbac.authorization.k8s.io/v1beta1
    kind: ClusterRoleBinding
    metadata:
      name: eks-admin
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: ClusterRole
      name: cluster-admin
    subjects:
    - kind: ServiceAccount
      name: eks-admin
      namespace: kube-system
    EOF

    kubectl proxy --port=8001 --address=0.0.0.0 --disable-filter=true &
    kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep eks-admin | awk '{print $1}')

http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#!/login


## Dashboard (alt 2)

    export DASHBOARD_VERSION="v2.0.0"    
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/${DASHBOARD_VERSION}/aio/deploy/recommended.yaml

    kubectl proxy --port=8001 --address=0.0.0.0 --disable-filter=true &

### Opvragen token

    kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep eks-admin | awk '{print $1}')

### Link

http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#!/login

## Ingress
Inrichten van het cluster

    CLUSTER_NAME=enschede
    
    helm install incubator/aws-alb-ingress-controller \
      --set clusterName=$CLUSTER_NAME \
      --set autoDiscoverAwsRegion=true \
      --set autoDiscoverAwsVpcID=true

### Ingress configuration

    apiVersion: networking.k8s.io/v1beta1
    kind: Ingress
    metadata:
      name: module1-ingress
      annotations:
        kubernetes.io/ingress.class: alb
        # required to use ClusterIP
        alb.ingress.kubernetes.io/target-type: ip
        # required to place on public-subnet
        alb.ingress.kubernetes.io/scheme: internet-facing
    {{/*    # use TLS registered to our domain, ALB will terminate the certificate*/}}
    {{/*    alb.ingress.kubernetes.io/certificate-arn: arn:aws:acm:us-west-2:XXXXXXXXXXXX:certificate/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx*/}}
        # respond to both ports
    {{/*    alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}, {"HTTPS":443}]'*/}}
        alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}]'
        # redirect to port 80 to port 443
    {{/*    alb.ingress.kubernetes.io/actions.ssl-redirect: '{"Type": "redirect", "RedirectConfig": { "Protocol": "HTTPS", "Port": "443", "StatusCode": "HTTP_301"}}'*/}}
      labels:
        app: module1
    spec:
      rules:
        - http:
            paths:
              - path: /*
                backend:
                  serviceName: module1
                  servicePort: 8080


Bronnen

- https://medium.com/@Joachim8675309/alb-ingress-with-amazon-eks-3d84cf822c85

## Logging to CloudWatch
- https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/deploy-container-insights-EKS.html
- https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Container-Insights-setup-EKS-quickstart.html


    curl https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/quickstart/cwagent-fluentd-quickstart.yaml | sed "s/{{cluster_name}}/enschede/;s/{{region_name}}/us-west-2/" | kubectl apply -f -

### Cloud Insights query
Voorbeeld van een filter

    fields @timestamp, @message
    | filter `kubernetes.labels.app`="module1"
    | sort @timestamp desc
    | limit 100


