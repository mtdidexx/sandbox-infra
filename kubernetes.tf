provider "kubernetes" {
  host = module.kubernetes-engine.cluster_endpoint

  cluster_ca_certificate = base64decode(
  module.kubernetes-engine.cluster_ca_certificate
  )
  token = data.google_client_config.current.access_token
}

module "kubernetes-engine" {
  source = "git@github.com:idexx-labs/terraform-google-kubernetes-engine?ref=v2.0.0"

  project_id                          = module.project.project_id
  project_number                      = module.project.project_number
  cluster_prefix                      = "gdos-poc"
  machine_type                        = var.machine_type
  host_project                        = module.project.project_id
  location                            = var.region
  subnet_region                       = var.region
  kubernetes_daily_maintenance_window = "06:00"
  max_node_count                      = 3
  network                             = "idexx-vpc"
  subnet                              = "idexx-vpc-us-east4"
}

// So GKE can get to the images that GoCD pushes to GCR
resource "google_storage_bucket_iam_member" "iam_gcr_bucket_access" {
  bucket = "artifacts.lims-tools-prod.appspot.com"
  member = "serviceAccount:${module.kubernetes-engine.default_compute_sa}"
  role   = "roles/storage.objectViewer"
}

resource "kubernetes_namespace" "test_admin_namespace" {
  metadata {
    name = "sb-exp"
    labels = {
      App = "sb-exp"
    }
  }
}

# Creates secrets for app main project, because gcloud sets this project during get-credentials call
resource "kubernetes_secret" "smoke_user_credentials" {
  metadata {
    namespace = kubernetes_namespace.test_admin_namespace.metadata[0].name
    name      = "smoke-user-credentials"
  }

  data = {
    # usage of sha and bcrypt forces string to be regenerated each time https://medium.com/@mclavel/terraform-password-hack-441eecd014e4
    # we want exactly this for even more security
    username = sha256(bcrypt(random_id.random.hex))
    password = sha256(bcrypt(random_id.random.hex))
  }
}
