locals {
  repos = yamldecode(file("${path.module}/repos.yaml"))["repos"]
}

resource "github_repository" "repos" {
  for_each           = local.repos
  name               = each.key
  description        = each.value.description
  visibility         = each.value.visibility
  has_issues         = each.value.has_issues
  has_projects       = each.value.has_projects
  has_wiki           = each.value.has_wiki
  allow_merge_commit = try(each.value.allow_merge_commit, false)
  allow_squash_merge = try(each.value.allow_squash_merge, true)
  allow_rebase_merge = try(each.value.allow_rebase_merge, false)
}

resource "github_repository_collaborators" "maintainers" {
  for_each   = local.repos
  repository = github_repository.repos[each.key].name
  
  dynamic "team" {
    for_each = try(each.value.collaborators.admin, [])
    content {
      team_id = github_team.geobee_teams[team.value].id
      permission = "admin"
    }
  }
  
  dynamic "team" {
    for_each = try(each.value.collaborators.maintain, [])
    content {
      team_id = github_team.geobee_teams[team.value].id
      permission = "maintain"
    }
  }
  
  dynamic "team" {
    for_each = try(each.value.collaborators.triage, [])
    content {
      team_id = github_team.geobee_teams[team.value].id
      permission = "triage"
    }
  }
  
  dynamic "team" {
    for_each = try(each.value.collaborators.push, [])
    content {
      team_id = github_team.geobee_teams[team.value].id
      permission = "push"
    }
  }
  
  dynamic "team" {
    for_each = try(each.value.collaborators.pull, [])
    content {
      team_id = github_team.geobee_teams[team.value].id
      permission = "pull"
    }
  }
}

resource "github_branch" "main" {
  for_each   = local.repos
  repository = github_repository.repos[each.key].name
  branch     = try(each.value.pages.branch, "main")
}

resource "github_branch_default" "main" {
  for_each   = local.repos
  repository = github_repository.repos[each.key].name
  branch     = try(each.value.pages.branch, "main")
}

resource "github_branch_protection" "main" {
  for_each                        = local.repos
  repository_id                   = github_repository.repos[each.key].name
  pattern                         = try(each.value.pages.branch, "main")
  enforce_admins                  = false
  allows_deletions                = false
  require_conversation_resolution = true
  allows_force_pushes             = false

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    restrict_dismissals             = true
    require_code_owner_reviews      = true
    required_approving_review_count = 1
    require_last_push_approval      = true
    dismissal_restrictions = [
      github_team.geobee_teams["breakglass"].id
    ]
  }

  restrict_pushes {
    push_allowances = [
      github_team.geobee_teams["breakglass"].id
    ]
  }
}
