variable "ec2_ssh_public_key_file" {
  type        = string
  description = "Path to SSH public key"
}

variable "ec2_keypair_name" {
  type        = string
  description = "Name of EC2 keypair name"
}

variable "ec2_image_id" {
  type = string
  description = "ID of EC2 CentOS AMI"
}
