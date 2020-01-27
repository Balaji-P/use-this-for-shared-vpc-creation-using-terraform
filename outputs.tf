output "shared-vpc-name" {
  value = module.project.shared_vpc_host_project-id
}

output "afrl-big-data-project-id" {
  value = module.project.afrl_big_data_project_id
}

output "afrl-app-engine-project-id" {
  value = module.project.afrl_app_engine_project_id
}

output "afrl-cloud-composer-project-id" {
  value = module.project.afrl_cloud_composer_project_id
}

output "afrl-shared-vpc-network-name" {
  value = module.project.shared_vpc_network_name
}

output "afrl-shared-vpc-subnet-1" {
  value = module.project.shared_vpc_subnetwork_1
}

output "afrl-shared-vpc-subnet-cidr_block" {
  value = module.project.shared_vpc_subnetwork_cidr_block
}

output "shared_vpc_network_id" {
  value = module.project.shared_vpc_network_id
}

output "shared_vpc_host_project" {
  value = module.project.shared_vpc_project_link
}