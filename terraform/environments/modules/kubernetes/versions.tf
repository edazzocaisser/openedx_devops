#------------------------------------------------------------------------------
# written by: Lawrence McDaniel
#             https://lawrencemcdaniel.com/
#
# date: Mar-2022
#
# usage: create an EKS cluster
#------------------------------------------------------------------------------
terraform {
  required_version = "~> 1.1"

  required_providers {
    aws        = "~> 4.15"
    local      = "~> 2.2"
    random     = "~> 3.2"
    kubernetes = "~> 2.11"
  }
}
