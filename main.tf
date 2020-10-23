provider "google" {}
provider "google-beta" {}
provider "random" {}
provider "null" {}

data "google_client_config" "current" {}

module "project" {
  source = "git@github.com:idexx-labs/terraform-google-project?ref=v2.0.0"

  cost_center = "u143"
  folder_id   = var.folder_id
  prefix      = var.prefix
  system      = var.system
  env         = var.env
}

module "vpc" {
  source = "git@github.com:idexx-labs/terraform-google-vpc.git?ref=v2.1.0"

  project_id = module.project.project_id
  subnets = [
    {
      subnet_name   = "idexx-vpc-us-east4"
      subnet_range  = "10.140.0.0/20"
      subnet_region = "us-east4"
    },
  ]
  secondary_ranges = {
    idexx-vpc-us-east4 = [
      {
        range_name    = "hc-k8s-services-europe-west1"
        ip_cidr_range = "10.141.0.0/20"
      },
    ]
  }
}

resource "google_project_service" "this" {
  count = length(var.services)
  project = module.project.project_id
  service = element(var.services, count.index)
}

# Random ID Resource
# https://www.terraform.io/docs/providers/random/r/id.html
resource "random_id" "random" {
  prefix      = "tf"
  byte_length = "3"
}