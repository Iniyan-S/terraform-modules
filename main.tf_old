terraform {
  # required_version = "~>1.0.0"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~>5.0"
    }
  }
}


provider "aws" {
  region = "eu-west-2"
#   profile = "excelencia"
#   assume_role {
#     role_arn = "arn:aws:iam::XXXXXX:role/TerraformDeployRole"
#   }
}

module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"

  cluster_name = "my-ecs-cluster"
}

