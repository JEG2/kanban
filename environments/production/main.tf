module "swarm" {
  source           = "../../modules/cloud/aws/compute/swarm"
  private_key_path = "${path.module}/private_key.pem"
}

module "repository_secrets" {
  source = "../../modules/integrations/github/secrets"
  secrets = {
    "PRIVATE_KEY"= module.swarm.private_key,
    "AWS_ACCESS_KEY_ID"= var.aws_access_key_id,
    "AWS_SECRET_ACCESS_KEY"= var.aws_secret_access_key,
    "AGE_KEY"= var.age_key,
    "GH_PAT"= var.gh_pat
  }
  repository = "kanban"
  github_owner = "jeg2"
}

module "contributing_workflow" {
  source = "../../modules/integrations/github/contributing_workflow"
  repository = "kanban"
  github_owner = "jeg2"
  status_checks = [
    "Compile with mix test, format, and Dialyzer"
  ]
}

output "swarm_ssh_command" {
  value = module.swarm.ssh_command
}
