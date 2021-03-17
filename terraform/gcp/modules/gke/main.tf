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
  description = "project_id"
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
  project = var.project_id
  region  = var.region
  zone    = var.zone
}
