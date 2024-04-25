terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.42.0"
    }
  }
   backend "s3" {
    bucket = "terraforms3bucket007"
    key    = "DynamoDbStateLock/terraform.tfstate"
    region = "ap-south-1"
    dynamodb_table = "dynamodb-state-information"
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_iam_user" "user" {
  name = "dummyyy"
}
