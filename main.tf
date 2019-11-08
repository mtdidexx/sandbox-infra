# Google Cloud Provider
# https://www.terraform.io/docs/providers/google/index.html

provider "google" {
  project = var.project
  region = var.region
}

provider "random" {
  version = "2.1.2"
}

# Random ID Resource
# https://www.terraform.io/docs/providers/random/r/id.html
resource "random_id" "random" {
  prefix      = "tf"
  byte_length = "3"
}

resource "random_id" "proxy_user_password" {
  byte_length = "12"
}

# Project Service Resource
# https://www.terraform.io/docs/providers/google/r/google_project_service.html

resource "google_project_service" "gdos_service" {
  count   = length(var.services)
  project = var.project
  service = element(var.services, count.index)

  disable_on_destroy = false
  disable_dependent_services = true
}
