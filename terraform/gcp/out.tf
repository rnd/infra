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
