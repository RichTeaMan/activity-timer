terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "richteaman-terraform-state"
    key    = "activity-timer/terraform.tfstate"
    region = "eu-west-2"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-2"
}
