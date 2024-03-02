#ec2-module variables
variable "instance_type" {
  type        = string
  description = "set aws instance type"
  default     = "t2.nano"
}



variable "aws_ec2_tag" {
  type        = map(any)
  description = "Common tag for resources"
  default = {
    values = "ec2-aCD"
  }
}

variable "sg_att_id" {
  type = string
  description = "security group ID"
}
