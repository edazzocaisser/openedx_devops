#------------------------------------------------------------------------------
# written by: Miguel Afonso
#             https://www.linkedin.com/in/mmafonso/
#
# date: Aug-2021
#
# usage: create a VPC to contain all Open edX backend resources.
#------------------------------------------------------------------------------
locals {
  # Automatically load stack-level variables
  stack_vars  = read_terragrunt_config(find_in_parent_folders("stack.hcl"))
  global_vars = read_terragrunt_config(find_in_parent_folders("global.hcl"))

  # Extract out common variables for reuse
  platform_name   = local.global_vars.locals.platform_name
  platform_region = local.global_vars.locals.platform_region
  aws_region      = local.global_vars.locals.aws_region
  stack           = local.stack_vars.locals.stack
  namespace       = local.stack_vars.locals.stack_namespace
  resource_name   = local.stack_vars.locals.stack_namespace

  tags = merge(
    local.stack_vars.locals.tags,
    local.global_vars.locals.tags,
  )
}


# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.

terraform {
  source = "../../modules//vpc"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  aws_region            = local.aws_region
  environment_namespace = local.environment_namespace
  name                  = "${local.resource_name}"
  cidr                  = "10.0.0.0/14"
  azs                   = ["${local.aws_region}a", "${local.aws_region}b", "${local.aws_region}c"]

  public_subnets      = ["10.0.0.0/18", "10.0.64.0/18", "10.0.128.0/18"]
  private_subnets     = ["10.1.0.0/16", "10.2.0.0/16", "10.3.0.0/16"]
  database_subnets    = ["10.0.192.0/21", "10.0.200.0/21"]
  elasticache_subnets = ["10.0.208.0/21", "10.0.216.0/21"]

  enable_ipv6 = false

  # NAT Gateway configuration
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  enable_dns_hostnames = true

  # a bit of foreshadowing:
  # AWS EKS uses tags for identifying resources which it interacts.
  # here we are tagging the public and private subnets with specially-named tags
  # that EKS uses to know where its public and internal load balancers should be placed.
  #
  # these tags are required, regardless of whether we're using EKS with EC2 worker nodes
  # or with a Fargate Compute Cluster.
  public_subnet_tags = {
    "kubernetes.io/cluster/${local.namespace}" = "shared"
    "kubernetes.io/role/elb"                   = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.namespace}" = "shared"
    "kubernetes.io/role/internal-elb"          = "1"
  }

  tags = local.tags
}
