data "terraform_remote_state" "afrl-bd-folder-id" {
  backend = "remote"
  config = {
    organization = "AFRLDigitalMFG"
    workspaces = {
      name = "folder"
    }
  }
}


module "project" {
  source          = "./modules/shared_vpc_projects"
  billing_account_id = var.billing_account_id
  folder_id       = data.terraform_remote_state.afrl-bd-folder-id.id
}