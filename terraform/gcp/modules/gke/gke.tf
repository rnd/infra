variable "gke_username" {
  default     = ""
  description = "gke username"
}

variable "gke_password" {
  default     = ""
  description = "gke password"
}

variable "gke_num_nodes" {
  default     = 1
  description = "number of gke nodes"
}

resource "google_container_cluster" "primary" {
  name     = "${var.cluster_name}-cluster"
  location = var.zone

  # we create the smallest possible default
  # node pool and immediately delete it.
  # as we don't want to use the default managed node pool.
  initial_node_count       = 1
  remove_default_node_pool = true

  master_auth {
    username = var.gke_username
    password = var.gke_password

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "${google_container_cluster.primary.name}-preemptible-node-pool"
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  node_count = var.gke_num_nodes

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
    ]

    labels = {
      env = "${var.cluster_name}-cluster"
    }

    preemptible  = true
    machine_type = "n1-standard-1"
    tags         = ["preemptible", "${var.cluster_name}-cluster"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}
