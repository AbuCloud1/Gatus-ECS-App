terraform {
  required_version = ">= 1.0"
  
  backend "s3" {
    bucket         = "abubakker-gatus-backend"
    key            = "staging_statefile/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
