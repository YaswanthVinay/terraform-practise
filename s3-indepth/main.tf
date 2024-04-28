terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.42.0"
    }
  }
  backend "s3" {
    bucket = "terraforms3bucket007"
    key    = "s3-indepth/terraform.tfstate"
    region = "ap-south-1"
  }
}

