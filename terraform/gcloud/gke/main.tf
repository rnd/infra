terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.52.0"
    }
  }
  required_version = "~> 0.14"
}

variable "cluster_name" {
  description = "cluster_name"
}

variable "region" {
  description = "region"
}

variable "zone" {
  description = "zone"
}

provider "google" {
  project = google_project.primary.project_id
  region  = var.region
  zone    = var.zone
}
