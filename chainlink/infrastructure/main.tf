terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "eu-west-1"
}
module "nomad_cluster" {
  source = "./nomad"

  subnet_id          = aws_subnet.chainlink_subnet.id
  security_group_ids = [aws_security_group.chainlink_ssh_group.id, aws_security_group.outside_internet_group.id]
  ec2_keypair_name   = var.ec2_keypair_name
  vpc                = aws_vpc.chainlink_vpc.id
  ec2_ami = var.ec2_image_id
}

resource "aws_vpc" "chainlink_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "chainlink_subnet" {
  vpc_id     = aws_vpc.chainlink_vpc.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_internet_gateway" "chainlink_gw" {
  vpc_id = aws_vpc.chainlink_vpc.id
}

resource "aws_route" "chainlink_nomad_route" {
  route_table_id         = aws_route_table.chainlink_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.chainlink_gw.id
}

resource "aws_route_table" "chainlink_route_table" {
  vpc_id = aws_vpc.chainlink_vpc.id
}

resource "aws_route_table_association" "chainlink_route_tbl_assoc" {
  subnet_id      = aws_subnet.chainlink_subnet.id
  route_table_id = aws_route_table.chainlink_route_table.id
}

resource "aws_security_group" "chainlink_ssh_group" {
  name   = "ssh_group"
  vpc_id = aws_vpc.chainlink_vpc.id

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "outside_internet_group" {
  name   = "outside_internet_group"
  vpc_id = aws_vpc.chainlink_vpc.id

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0 
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_key_pair" "deployer" {
  key_name   = var.ec2_keypair_name
  public_key = file(var.ec2_ssh_public_key_file)
}
