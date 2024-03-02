#ec2-module
data "aws_ami" "ami_name" {
  most_recent = true
  owners      = ["amazon"] #Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64*"]
  }
}

resource "aws_instance" "ec2_ressource" {
  ami             = data.aws_ami.ami_name.id
  instance_type   = var.instance_type
  key_name        = "devops-aCD"
  tags            = var.aws_ec2_tag
  vpc_security_group_ids = [var.sg_att_id]

  provisioner "remote-exec" {
    script = "../app_install.sh"
  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("C:/Users/Kusuka.fr/OneDrive - data5tb/Formations/BootCamp DevOps 17/cursus-devops/Terraform/terraform-project/secret/devops-aCD.pem")
    host = self.public_ip
    }
  }
}