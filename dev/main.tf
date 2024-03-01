provider "aws" {
  region     = "us-east-1"
  access_key = "AKIA4B2D2IYUT4DGPGX4"
  secret_key = "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"
}

terraform {
  backend "s3" {
    bucket = "tf-backend-acd-1"
    key = "acd.tfstates"
    region = "us-east-1"
    access_key = "AKIA4B2D2IYUT4DGPGX4"
    secret_key = "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"
  }
}

module "ec2" {
  source = "../modules/ec2-module"
  instance_type = "t2.micro"
  aws_ec2_tag = {
    Name = "ec2-dev-aCD"
  }
  sg_name = "dev-aCD-sg"
}