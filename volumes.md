## Kubernetes services

### Command

    kubectl get pv
    kubectl get pvc
    kubectl describe pvc <name>

### Volume in deployment

Mount a volume in the pod. Depending on the volume type, it can be access by more than one pod.
AWS-EBS is ReadWriteOnce, so excellent for a database volume.
Drivers for S3 available, ReadWriteMany

PersistentVolume and PersistentVolumeClaim are only needed for complex drivers (block devices, etc.)

Een PVC kan nodig zijn om een Helm package van een volume te voorzien

    apiVersion: apps/v1
    kind: Deployment
    spec:
      template:
        spec:
          containers:
          - image: enschede/kubernetes-module1:0.0.12-SNAPSHOT
            volumeMounts:
              - mountPath: /externalvolume
                name: pvc1
          volumes:
            # Add pvc, azuredisk, nfs, etc.
            - name: aws-ebs
              # AWS EBS
              awsElasticBlockStore:
                volumeID: blah
                fsType: ext4
            - name: emptydir-pvc
              # Directory in de container, is niet persistant
              emptyDir: {}
            - name: pvc1
              # Directory op host, prima setting in Docker Desktop
              hostPath:
                path: /Users/marc/mnt
                type: Directory
            - name: pvc1
              persistentVolumeClaim:
                claimName: module1-pvc

### PersistentVolumeClaim

    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
      name: module1-pvc
    spec:
      accessModes:
        - ReadWriteOnce
      volumeMode: Filesystem
      resources:
        requests:
          storage: 5Gi
      volumeName: my-pv
      storageClassName: hostpath

Let op; storageClassName lijkt belangrijk

### PersistentVolume

    apiVersion: v1
    kind: PersistentVolume
    metadata:
      name: my-pv
    spec:
      accessModes:
        - ReadWriteOnce
      persistentVolumeReclaimPolicy: Retain
      capacity:
        storage: 100Gi
      storageClassName: hostpath
      hostPath:
        path: /Users/marc/mnt
    
