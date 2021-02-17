

data "digitalocean_ssh_key" "syntropy" {
  name = "polkadot_validator" // name of keypair on digital ocean
}

resource "digitalocean_droplet" "syntropy-polkadot-monitoring" {
  image              = "ubuntu-20-04-x64"
  name               = "polkadot-monitoring"
  region             = "nyc1"
  size               = "s-2vcpu-4gb"
  private_networking = true

  ssh_keys = [
    data.digitalocean_ssh_key.syntropy.id
  ]

  connection {
    host        = self.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = file(var.pvt_key)
    timeout     = "2m"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = ["monitoring"]
}

