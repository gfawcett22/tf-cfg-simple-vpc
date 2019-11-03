terraform {
  required_version = "~> 0.12"

  backend "s3" {
    region         = "us-east-1"
    key            = "simple-vpc"
    bucket         = "simple-pipeline.tfstate"
    dynamodb_table = "terraform-state-lock"
  }
}

provider "aws" {
  version = "~> 2.0"
  region  = var.region
  profile = "personal"
}

