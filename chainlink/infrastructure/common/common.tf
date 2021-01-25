source "aws_vpc" "chainlink_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_security_group" "chainlink_ssh_group" {
  name = "ssh_group"
  vpc_id = "${aws_vpc.chainlink_vpc.id}"

  ingress {
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip" "nomad-ip" {
  vpc      = true
  instance = aws_instance.nomad-instance.id
}

resource "aws_key_pair" "deployer" {
  key_name   = var.ec2_keypair_name
  public_key = file("${var.ssh_public_key_file}")
}
