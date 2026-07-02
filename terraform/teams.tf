locals {
  teams = yamldecode(file("${path.module}/org.yaml"))["teams"]
}

resource "github_team" "geobee_teams" {
  for_each    = local.teams
  name        = each.key
  description = each.value.description
  privacy     = each.value.privacy
}

resource "github_membership" "geobee_users" {
  for_each = toset(distinct(flatten([
    for team_name, team in local.teams : concat(team.maintainers, team.members)
  ])))
  username = each.key
  role     = each.key == "c5haw" ? "admin" : "member"
}

resource "github_team_members" "geobee_team_maintainers" {
  for_each = local.teams
  team_id  = github_team.geobee_teams[each.key].id
  
  dynamic "members" {
    for_each = each.value.maintainers
    content {
      username = members.value
      role     = "maintainer"
    }
  }

  dynamic "members" {
    for_each = each.value.members
    content {
      username = members.value
      role     = "member"
    }
  }
}
