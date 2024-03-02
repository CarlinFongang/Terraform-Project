#ebs-module variables
variable "az_ebs" {
  description = "The AZ where the EBS volume will exist"
}

variable "size_ebs" {
  description = "The size of the EBS volume"
}

variable "type_ebs" {
  description = "The type of EBS volume"
  default     = "gp2"
}

variable "name_ebs" {
  description = "The name of the EBS volume"
}

variable "ec2_id_ebs" {
  description = "The ID of the EC2 instance to attach"
}

variable "device_name_ebs" {
  description = "The device name to attach the EBS volume to"
}
