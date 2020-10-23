module "cloud-sql" {
  source = "git@github.com:idexx-labs/terraform-google-cloud-sql?ref=v2.0.0"

  instance_name = "test-admin-instance"
  project_id    = module.project.project_id
  machine_tier  = var.machine_tier
  region        = var.region
  network       = "idexx-vpc"
}
resource "google_sql_user" "proxy_user" {
  project  = module.project.project_id
  instance = module.cloud-sql.sql_instance
  name     = "proxyuser"
  password = random_id.database_password.hex
}

resource "random_id" "database_password" {
  byte_length = 12
}

resource "google_sql_database" "gdos_db" {
  project  = module.project.project_id
  instance = module.cloud-sql.sql_instance
  name     = "test-admin-db"
}