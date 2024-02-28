provider "aws" {
  region     = "us-east-1"
  access_key = "AKIASW5DVDMAVLHX2FAQ"
  secret_key = "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"
}

terraform {
  backend "s3" {
    bucket = "tf-backend-acd-1"
    key = "acd-prod.tfstates"
    region = "us-east-1"
    access_key = "AKIASW5DVDMAVLHX2FAQ"
    secret_key = "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"
  }
}

module "ec2" {
  source = "../modules/ec2-module"
  instance_type = "t3.medium"
  aws_common_tag = {
    Name = "ec2-prod-aCD"
  }
  sg_name = "prod-aCD-sg"
}