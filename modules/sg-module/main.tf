resource "aws_security_group" "protocol_ressource_sg" {
  name        = var.name_sg
  description = "Allow HTTP and HTTPS inbound traffic and all outbound traffic"

  dynamic "ingress" {
    for_each = var.port_sg
    content {
      description = "ingress port ${ingress.value}"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "egress" {
    for_each = var.port_sg
    content {
      description = "egress port ${egress.value}"
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}