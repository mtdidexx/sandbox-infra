variable "folder_id" {
  type = string
  # Sandbox
  default     = "897209801107"
  description = "This is the GCP ID of the parent folder for this project. Get the ID by browsing to the folder that should contain this project and look for the folder path variable"
}

variable "prefix" {
  type = string
  default = "gdos"
  description = "Project names include a prefix, some sort of description as well as an environment."
}

variable "env" {
  type    = string
  default = "sb"
  description = "Project names include a prefix, some sort of description as well as an environment. For sandbox environments, leave this as sb"
}

variable "system" {
  type = string
  description = "Project names include a prefix, some sort of description as well as an environment. For sandbox environments, your name goes here"
}

variable "services" {
  type = list(string)

  # Remember that these services are used by the gdos-* projects, not the k8s ones
  default = [
//    "cloudtrace.googleapis.com",
//    "stackdriver.googleapis.com",
//    "monitoring.googleapis.com",
//    "logging.googleapis.com",
//    "sqladmin.googleapis.com",
//    "redis.googleapis.com",
//    "vpcaccess.googleapis.com",
//    "pubsub.googleapis.com",
  ]
}

variable "database_backup_max_age" {
  type    = string
  default = "45"
}


variable "region" {
  type    = string
  default = "us-east4"
}

variable "machine_type" {
  type    = string
  default = "n1-standard-1"
}

variable "machine_tier" {
  type        = string
  default     = "db-custom-1-4096"
  description = "Used by Cloud SQL"
}

# variable "group" {
#   type = string
#   default = "gdos-dev@idexx.com"
#   description = "Google Group ID used to grant access to Cloud Run Services"
# }

# // Result vars
# // Many of these aren't known until the project is created. We have a chicken and egg problem
# variable "default_service_account" {
#   type = string
#   description = "Project-specific service account used in pubsub push config"
# }

# variable "results_assay_push_endpoint" {
#   type = string
#   description = "used to configure pubsub"
# }

# variable "results_animal_push_endpoint" {
#   type = string
# }

# variable "cloud_run_sa" {
#   type = string
#   description = "Environment-specific Service Account for Cloud Run. There should be a better way to access this account rather than hard-coding it."
# }
