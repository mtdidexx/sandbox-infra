variable "project" {
  type = "string"
  default = "gdos-mdonahue-sb"
}

variable "region" {
  type    = string
  default = "us-east4"
}

variable "machine_tier" {
  type    = string
  default = "db-g1-small"
}

variable "services" {
  type = list(string)

  //  remember that these services are used by the gdos-* projects, not the k8s ones
  default = [
    "cloudtrace.googleapis.com",
    "stackdriver.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com",
    "sqladmin.googleapis.com",
    "storage-api.googleapis.com",
    "containerregistry.googleapis.com",
    "container.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "dns.googleapis.com",
    "cloudprofiler.googleapis.com",
    "runtimeconfig.googleapis.com",
    "iam.googleapis.com",
    "clouddebugger.googleapis.com",
    "cloudresourcemanager.googleapis.com",
  ]
}

variable "k8s-cluster-name" {
  type = string
  default = "sb-mdonahue-k8s-cluster"
}
