resource "google_project" "host_project" {
  name            = "afrl-shared-vpc-host-01"
  project_id      = "afrl-shared-vpc-host-01"
  folder_id = var.folder_id
  billing_account = var.billing_account_id
}

# A service project which will use the VPC.
resource "google_project" "service_project_1" {
  name            = "afrl-bd-sp-01"
  project_id      = "afrl-bd-sp-01"
  folder_id = var.folder_id
  billing_account = var.billing_account_id
}

# The other service project which will use the VPC.
resource "google_project" "service_project_2" {
  name            = "afrl-gae-sp-01"
  project_id      = "afrl-gae-sp-01"
  folder_id = var.folder_id
  billing_account = var.billing_account_id
}

# Service project for cloud composer
resource "google_project" "service_project_3" {
  name            = "afrl-cloud-composer-01"
  project_id      = "afrl-cloud-composer-01"
  folder_id = var.folder_id
  billing_account = var.billing_account_id
}


# Compute service needs to be enabled for all four new projects.
resource "google_project_service" "host_project" {
  project = google_project.host_project.project_id
  service = "compute.googleapis.com"
}

resource "google_project_service" "service_project_1" {
  project = google_project.service_project_1.project_id
  service = "compute.googleapis.com"
}

resource "google_project_service" "service_project_2" {
  project = google_project.service_project_2.project_id
  service = "compute.googleapis.com"
}

resource "google_project_service" "service_project_3" {
  project = google_project.service_project_3.project_id
  service = "compute.googleapis.com"
}

# Enable shared VPC hosting in the host project.
resource "google_compute_shared_vpc_host_project" "host_project" {
  project    = google_project.host_project.project_id
  depends_on = [google_project_service.host_project]
}

# Big Query service needs to be enabled for BD project.
resource "google_project_service" "enable_big_query_api" {
  project = google_project.service_project_2.project_id
  service = "bigquery.googleapis.com"
}

# Enable shared VPC in the two service projects - explicitly depend on the host
# project enabling it, because enabling shared VPC will fail if the host project
# is not yet hosting.
resource "google_compute_shared_vpc_service_project" "service_project_1" {
  host_project    = google_project.host_project.project_id
  service_project = google_project.service_project_1.project_id

  depends_on = [
    google_compute_shared_vpc_host_project.host_project,
    google_project_service.service_project_1,
  ]
}

resource "google_compute_shared_vpc_service_project" "service_project_2" {
  host_project    = google_project.host_project.project_id
  service_project = google_project.service_project_2.project_id

  depends_on = [
    google_compute_shared_vpc_host_project.host_project,
    google_project_service.service_project_2,
  ]
}

resource "google_compute_shared_vpc_service_project" "service_project_3" {
  host_project    = google_project.host_project.project_id
  service_project = google_project.service_project_3.project_id

  depends_on = [
    google_compute_shared_vpc_host_project.host_project,
    google_project_service.service_project_3,
  ]
}

# Create the hosted network.
resource "google_compute_network" "shared_network" {
  name                    = "afrl-shared-network"
  auto_create_subnetworks = "false"
  project                 = google_compute_shared_vpc_host_project.host_project.project

  depends_on = [
    google_compute_shared_vpc_service_project.service_project_1,
    google_compute_shared_vpc_service_project.service_project_2,
  ]
}

resource "google_compute_subnetwork" "afrl-subnet-01" {
  project = google_project.host_project.name
  name = "afrl-bd-subnet-01"
  network = google_compute_network.shared_network.name
  region = "us-central1"
  description = "Shared network for big data project"
  ip_cidr_range = "10.1.0.0/27"
  private_ip_google_access = true
  secondary_ip_range {
    ip_cidr_range = "10.20.0.0/22"
    range_name = "afrl-composer-pods-subnet"
  }secondary_ip_range {
    ip_cidr_range = "10.20.4.0/27"
    range_name = "afrl-composer-services-subnet"
  }

}