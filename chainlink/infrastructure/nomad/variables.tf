variable "subnet_id" {
  description = "Chainlink EC2 subnet id"
  type        = string
}

variable "security_group_ids" {
  description = "IDs of VPC security groups"
  type        = list
}

variable "vpc" {
  description = "ID of the instance VPC"
  type        = string
}

variable "ec2_keypair_name" {
  description = "Name of EC2 ssh keypair"
  type        = string
}

variable "ec2_ami" {
  type = string
  description = "ID of EC2 CentOS AMI"
}