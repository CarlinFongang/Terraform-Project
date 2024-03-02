#ebs-module

resource "aws_ebs_volume" "ebs_ressource" {
  availability_zone = var.az_ebs
  size              = var.size_ebs
  type              = var.type_ebs

  tags = {
    Name = var.name_ebs
  }
}

resource "aws_volume_attachment" "ebs_attach_ressource" {
  device_name = var.device_name_ebs
  volume_id   = aws_ebs_volume.ebs_ressource.id
  instance_id = var.ec2_id_ebs
  force_detach = true
}

