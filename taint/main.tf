terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.42.0"
    }
  }
  #have used backend as s3 ,in your case make sure that you create bucket and store your state file there

  backend "s3" {
    bucket = "terraforms3bucket007"
    key    = "taint-command/terraform.tfstate"
    region = "ap-south-1"
  }
}

provider "aws" {
  # Configuration options
  region = "ap-south-1"
}


#server-1
resource "aws_instance" "taint-server-1" {
  tags = {
    Name = "taint-server-1"
  }
  ami                         = var.ami
  instance_type               = "t2.micro"
  associate_public_ip_address = true
}
resource "aws_instance" "taint-server-2" {
  tags = {
    Name = "taint-server-2"
  }
  ami                         = var.ami
  instance_type               = "t2.micro"
  associate_public_ip_address = true
}
