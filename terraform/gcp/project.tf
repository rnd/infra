resource "random_id" "project_id" {
  byte_length = 4
  prefix      = "${var.project_name}-"
}

resource "google_project" "primary" {
  name            = var.project_name
  project_id      = random_id.project_id.hex
  org_id          = var.org_id
  billing_account = var.billing_account
}

resource "google_project_service" "primary" {
  project            = google_project.primary.project_id
  disable_on_destroy = false

  for_each = toset([
    "container.googleapis.com",
    "compute.googleapis.com",
    "dns.googleapis.com",
    "containerregistry.googleapis.com",
    "storage-api.googleapis.com",
  ])
  service = each.key
}
