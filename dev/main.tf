provider "aws" {
  region     = "us-east-1"
  access_key = "AKIASW5DVDMAVLHX2FAQ"
  secret_key = "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"
}

terraform {
  backend "s3" {
    bucket = "tf-backend-acd-1"
    key = "acd.tfstates"
    region = "us-east-1"
    access_key = "AKIASW5DVDMAVLHX2FAQ"
    secret_key = "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"
  }
}

module "ec2" {
  source = "../modules/ec2-module"
  instance_type = "t2.micro"
  aws_common_tag = {
    Name = "ec2-dev-aCD"
  }
  sg_name = "dev-aCD-sg"
}