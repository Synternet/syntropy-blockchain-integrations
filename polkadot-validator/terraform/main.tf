module "aws_validator" {
  source              = "./aws"
  ssh_public_key_file = var.ssh_public_key_file
}

module "digitalocean_monitoring" {
  source   = "./digitalocean"
  do_token = var.do_token
  pvt_key  = var.pvt_key
}
