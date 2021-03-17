output "org_id" {
  value       = var.org_id
  description = "GCP organization ID"
}

output "project_name" {
  value       = var.project_name
  description = "GCP project name"
}

output "project_id" {
  value       = google_project.primary.project_id
  description = "GCP project ID"
}

output "gke_region" {
  value       = module.gke.region
  description = "GKE region"
}

output "gke_cluster_name" {
  value       = module.gke.cluster_name
  description = "GKE cluster name"
}

output "gke_cluster_host" {
  value       = module.gke.cluster_host
  description = "GKE cluster host"
}
