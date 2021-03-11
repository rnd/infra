resource "google_project" "primary" {
  name        = var.project_name
  project_id  = var.project_id
  org_id      = var.org_id
  billing_account = var.billing_account
}

resource "google_project_service" "primary" {
  project             = google_project.primary.project_id
  disable_on_destroy  = false

  for_each = toset([
    "dns.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "containerregistry.googleapis.com",
    "storage-api.googleapis.com",
  ])
  service = each.key
}
