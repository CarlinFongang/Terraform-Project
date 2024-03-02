#ec2-module outputs
output "ec2_id_output" {
  value = aws_instance.ec2_ressource.id
}

output "ec2_az_output" {
  value = aws_instance.ec2_ressource.availability_zone
}