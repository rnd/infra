# Terraform

This directory contains a [Terraform](https://www.terraform.io/) configurations 
for provisioning a Kubernetes cluster on [Google Cloud](https://cloud.google.com/).

__NOTE:__ Currently this is more of like a learning material for me while i
exploring stuff and best practices. use this at your own risk.

---

### Prerequisites

You need a Google Cloud account and an active Google Cloud project with
billing enabled to start.

see: [Google Cloud Installation and Setup](https://cloud.google.com/deployment-manager/docs/step-by-step-guide/installation-and-setup) guide.

__NOTE:__ The recommended way to authenticate to the Google Cloud API is by using a [service account](https://cloud.google.com/docs/authentication/getting-started).
You can either specify the path to this key directly using the _GOOGLE_APPLICATION_CREDENTIALS_ environment variable or you can run 

```
$ gcloud auth application-default login
```

Alternatively, you can use the [project resource](gcloud/project.tf) to create
new project with the minimum set of Google CLoud APIs enabled to spin up new GKE
cluster.

```
$ terraform apply gcloud
```
