# Terraform

This directory contains a [Terraform](https://www.terraform.io/) configurations 
for provisioning a Kubernetes cluster on [Google Cloud](https://cloud.google.com/).

---

### Prerequisite

#### Google Cloud Account

You need a Google Cloud account and an active Google Cloud project with
billing enabled to start.

see: [Google Cloud Installation and Setup](https://cloud.google.com/deployment-manager/docs/step-by-step-guide/installation-and-setup) guide.

#### Terraform Admin Project

Rather than using the actual project where we will actively managing the
resources, using a standalone gcp project exclusively for Terraform will
allow us to manage static configuration such as terraform backend remote
state on separate project.

see: [Creating Terraform Admin Project](https://cloud.google.com/community/tutorials/managing-gcp-projects-with-terraform#create_the_terraform_admin_project)

#### Terraform Service Account

We will create service account with organization level IAM permission using the
admin project we created above, so we can manage the gcp resources on other projects within
organization.

#### Enable GCP APIs

```
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable cloudbilling.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable serviceusage.googleapis.com
gcloud services enable container.googleapis.com
```

see: [Creating Service Account for Terraform](https://cloud.google.com/community/tutorials/managing-gcp-projects-with-terraform#create_the_terraform_service_account)

#### Set up Terraform Remote Backend

We will store terraform states on `gcs` bucket we created under terraform admin
project above. First make sure that the service account that we created above
have access to manage `Cloud Storage` resources.

By default terraform will use `local` backend which will store terraform states
on local directory.

To configure terraform to use remote storage (gcs on this case), run this
snippet on our terraform root directory.

```
cat > backend.tf << EOF
terraform {
 backend "gcs" {
   bucket  = "${TF_ADMIN}"
   prefix  = "terraform/state/gcp"
 }
}
EOF
```

__NOTE:__ Make sure `$TF_ADMIN` is set and `backend.tf` does not using any variables in the config block, because variable is not allowed on this.

And finally, enable versioning for the remote storage so if we
accidentally corrupt the state, we can still recover it using
the older version of the state.

```
gsutil versioning set on gs://${TF_ADMIN}

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
