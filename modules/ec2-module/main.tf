data "aws_ami" "ami_name" {
  most_recent = true
  owners      = ["amazon"]
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
  security_groups = ["${aws_security_group.sg_protocol_ressource.name}"]

  provisioner "remote-exec" {
    inline = [ 
      "sleep 10",
      "sudo apt update -y",
      "sudo apt-get install nginx -y",
      "sudo systemctl start nginx",
    ]
  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("C:/Users/Kusuka.fr/OneDrive - data5tb/Formations/BootCamp DevOps 17/cursus-devops/Terraform/terraform-project/secret/devops-aCD.pem")
    host = self.public_ip
    }
  }
}

resource "aws_security_group" "sg_protocol_ressource" {
  name        = var.sg_name
  description = "Allow HTTP and HTTPS inbound traffic and all outbound traffic"

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH from VPC"
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
resource "aws_eip" "eip_ressource" {
  instance = aws_instance.ec2_ressource.id
  domain   = "vpc"
  provisioner "local-exec" {
    command = "echo PUBLIC IP: ${self.public_ip}; ID: ${aws_instance.ec2_ressource.id}; AZ: ${aws_instance.ec2_ressource.availability_zone} > info_ec2-tf.txt"
  }
}