terraform {
  backend "s3" {
    bucket = "terraforms3bucket007"
    key    = "s3-terraform/terraform.tfstate"
    region = "ap-south-1"
  }
}