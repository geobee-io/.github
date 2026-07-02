resource "github_organization_settings" "main" {
  billing_email = "billing@geobee.io"
  company = "GeoBee.io"
  blog = "https://geobee.io"
  email = "hive@geobee.io"
  twitter_username = "geobee"
  location = "London, UK"
  name = "GeoBee.io"
  description = "GeoBee.io - AI RiskOps & Geospatial Intelligence Observability Platform"
  has_organization_projects = true
  has_repository_projects = true
  default_repository_permission = "none"
  members_can_create_repositories = false
  members_can_create_public_repositories = false
  members_can_create_private_repositories = false
  members_can_create_internal_repositories = false
  members_can_create_pages = false
  members_can_create_public_pages = false
  members_can_create_private_pages = false
  members_can_fork_private_repositories = false
  web_commit_signoff_required = true
  advanced_security_enabled_for_new_repositories = false
  dependabot_alerts_enabled_for_new_repositories=  true
  dependabot_security_updates_enabled_for_new_repositories = true
  dependency_graph_enabled_for_new_repositories = true
  secret_scanning_enabled_for_new_repositories = false
  secret_scanning_push_protection_enabled_for_new_repositories = false
}
