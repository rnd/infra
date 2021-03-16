# Terraform

This directory contains a [Terraform](https://www.terraform.io/) configurations 
for provisioning a Kubernetes cluster on [Google Cloud](https://cloud.google.com/).

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

Alternatively, you can use the [project resource](gcp/project.tf) to create
new project with the minimum set of Google CLoud APIs enabled to spin up new GKE
cluster.

```
$ terraform plan gcp
```

### Set up the environment

```
$ export TF_VAR_org_id=ORG_ID
$ export TF_VAR_billing_account=BILLING_ACCOUNT_ID
 
$ export TF_VAR_project_name=paw-project
$ export TF_VAR_region=asia-southeast1
$ export TF_VAR_zone=asia-southeast1-b
 
$ export TF_VAR_cluster_name=paw-cluster
```
or

```
$ cp sample.terraform.tfvars terraform.tfvars
$ terraform -var-file=terraform.tfvars plan gcp
````

__NOTE:__ Terraform first will look into environement variables of it's own process then `terraform.tfvars` if present.
see: https://www.terraform.io/docs/language/values/variables.html#variable-definition-precedence
