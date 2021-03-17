variable "org_id" {
  description = "org_id"
}

variable "project_name" {
  description = "project_name"
}

variable "billing_account" {
  description = "billing_account"
}

variable "cluster_name" {
  description = "gke_cluster_name"
}
variable "region" {
  description = "gke_region"
}
variable "zone" {
  description = "gke_zone"
}

module "gke" {
  source       = "./modules/gke"
  project_id   = google_project.primary.project_id
  region       = var.region
  zone         = var.zone
  cluster_name = var.cluster_name
}
