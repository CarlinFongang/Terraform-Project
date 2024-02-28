variable "instance_type" {
  type        = string
  description = "set aws instance type"
  default     = "t2.nano"
}

variable "sg_name" {
  type        = string
  description = "set sg name"
  default     = "aCD-sg"
}

variable "aws_common_tag" {
  type        = map(any)
  description = "Common tag for resources"
  default = {
    values = "ec2-aCD"
  }
}


