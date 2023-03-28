#------------------------------------------------------------------------------
# written by: Lawrence McDaniel
#             https://lawrencemcdaniel.com
#
# date: Mar-2022
#
# usage: build an EKS with EC2 worker nodes and ALB
#------------------------------------------------------------------------------
locals {
  # Automatically load environment-level variables
  global_vars      = read_terragrunt_config(find_in_parent_folders("global.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  resource_name = local.environment_vars.locals.shared_resource_namespace
  environment_name = local.environment_vars.locals.environment
  environment_namespace = local.environment_vars.locals.environment_namespace

  tags = merge(
    local.environment_vars.locals.tags,
    { Name = "${local.environment_namespace}-eks" }
  )
}

dependencies {
  paths = [
    "../../../stacks/service/vpc",
    "../../../stacks/service/kubernetes",
    "../vpc"
    ]
}

dependency "vpc" {
  config_path = "../../../stacks/service/vpc"

  # Configure mock outputs for the `validate` and `init` commands that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs = {
    vpc_id           = "fake-vpc-id"
    public_subnets   = ["fake-public-subnet-01", "fake-public-subnet-02"]
    private_subnets  = ["fake-private-subnet-01", "fake-private-subnet-02"]
    database_subnets = ["fake-database-subnet-01", "fake-database-subnet-02"]
  }

}

dependency "kubernetes" {
  config_path = "../../../stacks/service/kubernetes"

  # Configure mock outputs for the `validate` and `init` commands that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs = {
    cluster_arn           = "fake-cluster-arn"
    cluster_certificate_authority_data = "fake-cert"
    cluster_endpoint = "fake-cluster-endpoint"
    cluster_id = "fake-cluster-id"
    cluster_oidc_issuer_url = "fake-oidc-issuer-url"
    cluster_platform_version = "fake-cluster-version"
    cluster_security_group_arn = "fake-security-group-arn"
    cluster_security_group_id = "fake-security-group-id"
    cluster_status = "fake-cluster-status"
    cluster_version = "fake-cluster-version"
    eks_managed_node_groups = "fake-managed-node-group"
    fargate_profiles = "fake-fargate-profile"
    node_security_group_arn = "fake-security-group-arn"
    node_security_group_id = "fake-security-group-id"
    oidc_provider = "fake-oidc-provider"
    oidc_provider_arn = "fake-provider-arn"
  }

}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../modules//kubernetes"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  environment_name      = local.environment_name
  resource_name         = local.resource_name
  environment_namespace = local.environment_namespace
  tags                  = local.tags
}
