# SQL Database Instance
# https://www.terraform.io/docs/providers/google/r/sql_database_instance.html

resource "google_sql_database_instance" "gdos_master" {
  project          = var.project
  name             = "gdos-instance-${random_id.random.hex}"
  database_version = "POSTGRES_9_6"
  region           = var.region

  settings {
    tier = var.machine_tier

    backup_configuration {
      enabled    = true
      start_time = "04:00"
    }

    availability_type = "ZONAL"
  }
}

# SQL Database Resource
# https://www.terraform.io/docs/providers/google/r/sql_database.html

resource "google_sql_database" "gdos_db" {
  project  = var.project
  name     = "test-admin-db"
  instance = google_sql_database_instance.gdos_master.name
}

# SQL User Resource
# https://www.terraform.io/docs/providers/google/r/sql_user.html

resource "google_sql_user" "proxy_user" {
  project  = var.project
  name     = "proxyuser"
  instance = google_sql_database_instance.gdos_master.name
  password = random_id.proxy_user_password.hex
}

# Service Account Resource
# https://www.terraform.io/docs/providers/google/r/google_service_account.html

//resource "google_service_account" "gdos_proxy_sa" {
//  project      = var.project
//  account_id   = "test-admin-cloud-sql"
//  display_name = "Project Level Service Account for Cloud SQL"
//
//  depends_on = [google_project_service.gdos_service]
//}
