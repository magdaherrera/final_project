terraform {
  required_version = ">= 0.12" #Required terraform version
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.63.0"
    }
  }

  #Store state file in remote aws s3 backend
  # backend "s3" {
  #   #why cannot used variables here
  #   bucket  = "terraform-aws-service-infra"
  #   key     = "terraform-talento-tech-production/terraform.tfstate"
  #   region  = "us-east-1"
  #   encrypt = true
  # }

}

provider "random" {}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = var.aws_resource_tags
  }
}