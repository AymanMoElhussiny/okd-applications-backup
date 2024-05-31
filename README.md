# okd-applications-backup
A project for configure backup &amp; restore for stateful applications on OKD 

## Steps
- set up S3 compatible **object store** for ste backup and restore resouces on the Demo I am using Minio deployed on OKD following instruction in [Setup Minio](Minio/README.md )
- install OADP operator from operator Hub in Openshift-adp
- create secret to access minio
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: cloud-credentials
  labels:
    component: minio
stringData:
  cloud: |
    [default]
    aws_access_key_id =<minio_user> 
    aws_secret_access_key = <minio_password>
```
- create DataProtectionApplication
```yaml
apiVersion: openshift-adp.openshift.io/v1alpha1
kind: DataProtectionApplication
metadata:
  name: velero-sample
  namespace: openshift-adp
spec:
  backupLocations:
    - velero:
        config:
          insecureSkipTLSVerify: 'true'
          profile: default
          region: us-east-1
          s3ForcePathStyle: 'true'
          s3Url: '<miniapi route>' # s3 url
        credential:
          key: cloud
          name: cloud-credentials
        default: true
        objectStorage:
          bucket: oadp #bucket_name
          prefix: velero
        provider: aws
  configuration:
    restic:
      enable: true
    velero:
      defaultPlugins:
        - aws
```
4- create backup resource

apiVersion: velero.io/v1
kind: Backup
metadata:
  name: postgres-presist-backup #backup_resource_name
  namespace: openshift-adp
spec:
  defaultVolumesToRestic: true
  includedNamespaces:
    - postgres-presist #namespace
  storageLocation: velero-sample-1 #storage-sample
  ttl: 720h0m0s



5- create a restore resource 
```yaml
apiVersion: velero.io/v1
kind: Restore
metadata:
  name: postgres-presistent-restore
  namespace: openshift-adp
spec:
  backupName: postgres-presist-backup
  includedResources:
    - persistentvolume
    - deploymentconfigs
    - persistentvolumeclaims
    - pods
  restorePVs: true
```
## References
1. [About Openshift API for Data Protection](https://docs.openshift.com/container-platform/latest/backup_and_restore/application_backup_and_restore/installing/about-installing-oadp.html)

