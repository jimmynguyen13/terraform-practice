provider "aws" {
  region = "us-west-2"
}

# module "vpc" {
#   source = "thinhnpptit/vpc/aws"
#   version = "1.0.0"

#   vpc_cidr_block = "10.0.0.0/16"
#   private_subnet    = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
#   public_subnet     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
#   availability_zone = ["us-west-2a", "us-west-2b", "us-west-2c"]
# }

locals {
  project = "terraform-practice"
}

module "networking" {
  source = "./modules/networking"

  project          = local.project
  vpc_cidr         = "10.0.0.0/16"
  private_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets   = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  database_subnets = ["10.0.7.0/24", "10.0.8.0/24", "10.0.9.0/24"]
}

module "database" {
  source = "./modules/database"

  project = local.project
  vpc     = module.networking.vpc
  sg      = module.networking.sg
}

module "autoscaling" {
  source = "./modules/autoscaling"
}
