# Use the official AWS provider from HashiCorp
# Use AWS provider version 5.x (but not 6.x)

terraform {
							   
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.5.0"
						 
}

# Set AWS region using a variable

provider "aws" {
  region = var.aws_region
}
