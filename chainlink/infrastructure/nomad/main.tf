resource "aws_instance" "nomad_server" {
  ami                         = var.ec2_ami
  instance_type               = "t3.small"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = concat(var.security_group_ids, [aws_security_group.nomad_server_ports.id])
  key_name                    = var.ec2_keypair_name
  associate_public_ip_address = true
}

resource "aws_instance" "nomad_clients" {
  count                       = 5 
  ami                         = var.ec2_ami
  instance_type               = "t3.medium"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = concat(var.security_group_ids)
  key_name                    = var.ec2_keypair_name
  associate_public_ip_address = true

  ebs_block_device {
    device_name = "/dev/sdb"
    volume_type = "gp2"
    volume_size = 50
  }
}

resource "aws_security_group" "nomad_server_ports" {
  name   = "nomad_group"
  vpc_id = var.vpc
  ingress {
    from_port   = 4646
    to_port     = 4646
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 4647
    to_port     = 4647
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 4648
    to_port     = 4648
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


