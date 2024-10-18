provider "aws" {
  region =  local.region
  profile = var.profile
}

terraform {
  required_version = ">=1.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.49"
    }
  }
}