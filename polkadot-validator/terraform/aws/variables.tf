variable "ssh_public_key_file" {
  type        = string
  description = "Path to SSH public key" // stored in terraform.tfvars
}

variable "state_project" {
  default = "polkadot_validator"
}

variable "aws_profile" {
  default = "syntropy"
}

variable "aws_creds_file" {
  default = "~/.aws/credentials"
}

variable "project_id" {
  default = "my_project"
}

variable "location" {
  default = "us-east-1"
}

variable "zone" {
  default = "us-east-1a"
}

variable "machine_type" {
  default = "m4.large"
}


variable "ssh_user" {
  default = "ubuntu"
}

variable "node_count" {
  default = 1
}

variable "image" {
  default = "ami-03d315ad33b9d49c4" // Ubuntu 20.04 LTS
}
