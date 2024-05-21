resource "google_service_account" "main" {
  project    = var.project
  account_id = var.name

  display_name = "SA for cleanroom VM instance"
}
