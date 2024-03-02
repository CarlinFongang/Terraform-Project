variable "name_sg" {
  type        = string
  description = "set sg name"
  default     = "aCD-sg"
}

variable "port_sg" {
  type    = list(number)
  default = [22, 80, 443]
}