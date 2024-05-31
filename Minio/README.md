## Minio
Minio is a high-performance, S3 compatible object store. It can be deployed on a wide variety of platforms, and it comes in multiple flavors.

## Pre-quisites
- Access to an OpenShift cluster
- Namespace-level admin permissions, or permission to create your own project

## Setting up Minio on Openshift
1- Create New-Project called Minio
2- deploy minio.yaml that is foung in [Minio.yaml](minio.yaml)
3- login to minio-ui with minio-secret after the deployment finishes
4- create bucket for oadp.
