output "shared_vpc_host_project-id" {
  value = google_project.host_project.id
}

output "afrl_big_data_project_id" {
  value = google_project.service_project_1.id
}

output "afrl_app_engine_project_id" {
  value = google_project.service_project_2.id
}

output "afrl_cloud_composer_project_id" {
  value = google_project.service_project_3.id
}

output "shared_vpc_network_name" {
  value = google_compute_network.shared_network.name
}

output "shared_vpc_subnetwork_1" {
  value = google_compute_subnetwork.afrl-subnet-01.name
}

output "shared_vpc_subnetwork_cidr_block" {
  value = google_compute_subnetwork.afrl-subnet-01.ip_cidr_range
}