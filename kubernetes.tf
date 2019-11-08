//provider "kubernetes" {
//  host = "${google_container_cluster.sb-k8s-cluster.endpoint}"
//  username = "${google_container_cluster.sb-k8s-cluster.master_auth.0.username}"
//  password = "${google_container_cluster.sb-k8s-cluster.master_auth.0.password}"
//  client_certificate = "${base64decode(google_container_cluster.sb-k8s-cluster.master_auth.0.client_certificate)}"
//  client_key = "${base64decode(google_container_cluster.sb-k8s-cluster.master_auth.0.client_key)}"
//  cluster_ca_certificate = "${base64decode(google_container_cluster.sb-k8s-cluster.master_auth.0.cluster_ca_certificate)}"
//}
//
//resource "google_container_cluster" "sb-k8s-cluster" {
//  project = var.project
//  name = var.k8s-cluster-name
//  location = var.region
//  remove_default_node_pool = true
//  description = "K8s Cluster for sandbox projects"
//  depends_on = [google_project_service.gdos_service]
//  initial_node_count = 3
//
//  master_auth {
//    username = ""
//    password = ""
//    client_certificate_config {
//      issue_client_certificate = false
//    }
//  }
//}
//
//resource "google_container_node_pool" "primary-node-pool" {
//  project = var.project
//  name = "sb-standalone-node-pool"
//  location = var.region
//  cluster = "${google_container_cluster.sb-k8s-cluster.name}"
//  node_count = 1
//
//  node_config {
//    oauth_scopes = [
//      "https://www.googleapis.com/auth/cloud-platform",
//      "https://www.googleapis.com/auth/compute",
//      "https://www.googleapis.com/auth/devstorage.read_write",
//      "https://www.googleapis.com/auth/logging.write",
//      "https://www.googleapis.com/auth/monitoring",
//    ]
//    tags = ["sandbox", "gdos"]
//  }
//  autoscaling {
//    max_node_count = 4
//    min_node_count = 1
//  }
//  management {
//    auto_repair = true
//    auto_upgrade = true
//  }
//}
//
//resource "kubernetes_namespace" "test_admin_namespace" {
//  metadata {
//    name = "test-admin"
//    labels = {
//      App = "test-admin"
//    }
//  }
//  depends_on = [google_container_cluster.sb-k8s-cluster]
//}
//
//// namespaces for CD Lunch and Learn
//resource "kubernetes_namespace" "exp_namespace" {
//  metadata {
//    name = "exp"
//    labels = {
//      App = "exp"
//    }
//  }
//  depends_on = [google_container_cluster.sb-k8s-cluster]
//}
//resource "kubernetes_namespace" "uat_namespace" {
//  metadata {
//    name = "uat"
//    labels = {
//      App = "uat"
//    }
//  }
//  depends_on = [google_container_cluster.sb-k8s-cluster]
//}
//resource "kubernetes_namespace" "prod_namespace" {
//  metadata {
//    name = "prod"
//    labels = {
//      App = "prod"
//    }
//  }
//  depends_on = [google_container_cluster.sb-k8s-cluster]
//}
//
//# Creates secrets for app main project, because gcloud sets this project during get-credentials call
//resource "kubernetes_secret" "smoke_user_credentials" {
//  metadata {
//    name      = "smoke-user-credentials"
//  }
//
//  data = {
//    # usage of sha and bcrypt forces string to be regenerated each time https://medium.com/@mclavel/terraform-password-hack-441eecd014e4
//    # we want exactly this for even more security
//    username = sha256(bcrypt(random_id.random.hex))
//    password = sha256(bcrypt(random_id.random.hex))
//  }
//}
//
//resource "kubernetes_secret" "k8s_secret" {
//  metadata {
//    namespace = "test-admin"
//    name = "db-credentials"
//  }
//  data = {
//    username = "postgres"
//    password = "idexx123"
//  }
//}