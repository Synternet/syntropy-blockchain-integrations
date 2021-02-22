resource "aws_key_pair" "key-syntropy-polkadot" {
  key_name   = "syntropy-polkadot"
  public_key = file(var.ssh_public_key_file)
}

resource "aws_vpc" "main-syntropy-polkadot" {
  cidr_block = "172.26.0.0/16"

  enable_dns_hostnames = true

  enable_dns_support = true

  tags = {
    Name = "syntropy-polkadot"
  }
}

resource "aws_subnet" "main-syntropy-polkadot" {
  cidr_block = cidrsubnet(aws_vpc.main-syntropy-polkadot.cidr_block, 3, 1)

  vpc_id = aws_vpc.main-syntropy-polkadot.id

  availability_zone = var.zone

  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "main-syntropy-polkadot" {
  vpc_id = aws_vpc.main-syntropy-polkadot.id

  tags = {
    Name = "syntropy-polkadot"
  }
}

resource "aws_route_table" "main-syntropy-polkadot" {
  vpc_id = aws_vpc.main-syntropy-polkadot.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-syntropy-polkadot.id
  }

  tags = {
    Name = "syntropy-polkadot"
  }
}

resource "aws_route_table_association" "main-syntropy-polkadot" {
  subnet_id      = aws_subnet.main-syntropy-polkadot.id
  route_table_id = aws_route_table.main-syntropy-polkadot.id
}

resource "aws_security_group" "main-syntropy-polkadot" {
  name   = "externalssh"
  vpc_id = aws_vpc.main-syntropy-polkadot.id
}

resource "aws_security_group_rule" "externalssh-syntropy-polkadot" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.main-syntropy-polkadot.id
}

resource "aws_security_group_rule" "p2p-syntropy-polkadot" {
  type        = "ingress"
  from_port   = 30333
  to_port     = 30333
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.main-syntropy-polkadot.id
}

resource "aws_security_group_rule" "p2p-proxy-syntropy-polkadot" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.main-syntropy-polkadot.id
}

resource "aws_security_group_rule" "vpn-syntropy-polkadot" {
  type        = "ingress"
  from_port   = 51820
  to_port     = 51820
  protocol    = "udp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.main-syntropy-polkadot.id
}

resource "aws_security_group_rule" "node-exporter-syntropy-polkadot" {
  type        = "ingress"
  from_port   = 9100
  to_port     = 9100
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.main-syntropy-polkadot.id
}

resource "aws_security_group_rule" "allow_all-syntropy-polkadot" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.main-syntropy-polkadot.id
}

resource "aws_instance" "main-syntropy-polkadot" {
  ami           = var.image
  instance_type = var.machine_type
  key_name      = "syntropy-polkadot"

  subnet_id              = aws_subnet.main-syntropy-polkadot.id
  vpc_security_group_ids = [aws_security_group.main-syntropy-polkadot.id]

  root_block_device {
    volume_size = 400
  }

  lifecycle {
    create_before_destroy = true // TODO: dont destrop becaue of IP
  }

  tags = {
    Name = "syntropy-polkadot"
  }
}
