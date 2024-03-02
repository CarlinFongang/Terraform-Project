provider "aws" {
  region     = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "backend-acd"
    key = "prod-acd.tfstates"
    region = "us-east-1"
  }
}

module "ec2_instance" {
  source = "../modules/ec2-module"
  instance_type = "t3.medium"
  sg_att_id = module.sg.output_sg_id
  aws_ec2_tag = {
    Name = "ec2-prod-aCD"
  }
}

module "ebs_volume" {
  source       = "../modules/ebs-module"
  az_ebs       = module.ec2_instance.ec2_az_output  
  size_ebs     = 44
  type_ebs     = "gp2"  
  name_ebs     = "ebs-prod-aCD"
  ec2_id_ebs   = module.ec2_instance.ec2_id_output 
  device_name_ebs = "/dev/sdf"
}

module "eip_address" {
  source = "../modules/eip-module"
  eip_name = "eip-prod-aCD"
  ec2_id = module.ec2_instance.ec2_id_output
}

resource "null_resource" "export_info" {
    provisioner "local-exec" {
    command = "echo PUBLIC IP : ${module.eip_address.eip_output}; ID: ${module.ec2_instance.ec2_id_output}; AZ: ${module.ec2_instance.ec2_az_output} > info_prod_aCD.txt"
  }  
}

module "sg" {
  source = "../modules/sg-module"
  name_sg = "prod-sg-aCD"
}