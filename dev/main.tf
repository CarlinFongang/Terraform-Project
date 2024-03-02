provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAYXE474GNA65A4LLN"
  secret_key = "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"
}

terraform {
  backend "s3" {
    bucket = "backend-acd-1"
    key = "dev-acd.tfstates"
    region = "us-east-1"
    access_key = "AKIAYXE474GNA65A4LLN"
    secret_key = "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"
  }
}

module "ec2_instance" {
  source = "../modules/ec2-module"
  instance_type = "t2.micro"
  sg_att_id = module.sg.output_sg_id
  aws_ec2_tag = {
    Name = "dev-aCD-ec2"
  }
}

module "ebs_volume" {
  source       = "../modules/ebs-module"
  az_ebs       = module.ec2_instance.ec2_az_output  
  size_ebs     = 8.0  
  type_ebs     = "gp2"  
  name_ebs     = "dev-aCD-ebs"
  ec2_id_ebs   = module.ec2_instance.ec2_id_output 
  device_name_ebs = "/dev/sdf"
}

module "eip_address" {
  source = "../modules/eip-module"
  eip_name = "dev-aCD-eip"
  ec2_id = module.ec2_instance.ec2_id_output
}

resource "null_resource" "export_info" {
    provisioner "local-exec" {
    command = "echo PUBLIC IP : ${module.eip_address.eip_output}; ID: ${module.ec2_instance.ec2_id_output}; AZ: ${module.ec2_instance.ec2_az_output} > info_dev_aCD.txt"
  }  
}

module "sg" {
  source = "../modules/sg-module"
  name_sg = "dev-aCD-sg"
}