resource "google_project" "main_project" {
  name            = "exp-ansible-newrelic"
  project_id      = "exp-ansible-newrelic-${random_id.main_project.hex}"
  folder_id       = var.folder_id
  billing_account = var.billing_account
}
