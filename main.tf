terraform {
  backend "s3" {
    bucket = "terraforms3bucket007"
    key    = "dev/terraform.tfstate"
    region = "ap-south-1"
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.42.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"

}
resource "aws_iam_user" "iam-user" {
  name = "demo-user"

}