resource "aws_eip" "eip_ressource" {
  instance = var.ec2_id
  domain   = "vpc"
  tags = {
    Name = var.eip_name
  }
}


