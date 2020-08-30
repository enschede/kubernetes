# Mapping pods to nodes

Het is mogelijk een pod op een specifieke node te laten landen, zie voorbeeld.
Het is moeilijker om restricties aan een node te koppelen. Zie document https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/

### EKS nodes definition

    apiVersion: eksctl.io/v1alpha5
    kind: ClusterConfig
    metadata:
      name: enschede
    nodeGroups: of managedNodeGroups:
      - name: ng-2
        labels: {role: worker}
        tags:
          nodegroup-role: worker

### Pod definition

    apiVersion: apps/v1
    kind: Deployment
    spec:
      template:
        spec:
          nodeSelector:
            role: worker


