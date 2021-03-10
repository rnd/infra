terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.52.0"
    }
  }

  required_version = "~> 0.14"
}

variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
}

variable "zone" {
  description = "zone"
}

variable "cluster_name" {
  description = "cluster_name"
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone	  = var.zone
}
