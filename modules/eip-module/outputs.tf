output "eip_output" {
  value = aws_eip.eip_ressource.public_ip
}

output "eip_name_output" {
  value = aws_eip.eip_ressource.tags
}