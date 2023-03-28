#------------------------------------------------------------------------------
# written by: Lawrence McDaniel
#             https://lawrencemcdaniel.com/
#
# date: Feb-2022
#
# usage: create global parameters, exposed to all
#        Terragrunt modules in this repository.
#------------------------------------------------------------------------------
locals {
  platform_name              = "prod"
  platform_region            = "usa"
  shared_resource_identifier = "service"
  shared_resource_namespace  = "prod-usa-service"
  root_domain                = "da-aws-training.uk"
  services_subdomain         = "service.da-aws-training.uk"
  aws_region                 = "us-east-1"
  account_id                 = "885156022110"
  studio_subdomain           = "studio"

  tags = {
    "cookiecutter/platform_name"                = local.platform_name
    "cookiecutter/platform_region"              = local.platform_region
    "cookiecutter/shared_resource_identifier"   = local.shared_resource_identifier
    "cookiecutter/root_domain"                  = local.root_domain
    "cookiecutter/services_subdomain"           = local.services_subdomain
    "cookiecutter/terraform"                    = "true"
  }

}

inputs = {
  platform_name    = local.platform_name
  platform_region  = local.platform_region
  aws_region       = local.aws_region
  account_id       = local.account_id
  root_domain      = local.root_domain
}
