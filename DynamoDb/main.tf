terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.42.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "ap-south-1"
}
#have used backend as s3 ,in your case make sure that you create bucket and store your state file there
terraform {
  backend "s3" {
    bucket = "terraforms3bucket007"
    key    = "StateLock/DynamodDb-StateLock/terraform.tfstate"
    region = "ap-south-1"
  }
}

