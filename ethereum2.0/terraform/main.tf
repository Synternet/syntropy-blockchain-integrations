terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "1.14.0"
    }
  }
}

provider "linode" {
  token = var.linode_token
}

provider "google" {
  credentials = file(var.gcp_credentials_file)
  project     = var.gcp_project_id
  region      = var.gcp_region
  zone        = var.gcp_zone
}

resource "random_password" "linode_root_password" {
  length           = 16
  override_special = "_%@"
  special          = true
}

resource "linode_instance" "ethereum_node" {
  image           = "linode/ubuntu18.04"
  label           = "ethereum-node"
  group           = "terraform"
  region          = "eu-central"
  type            = "g6-standard-4"
  authorized_keys = [chomp(file(var.ssh_public_key_file))]
  root_pass       = random_password.linode_root_password.result
}

resource "google_compute_instance" "monitoring_node" {
  name         = "monitoring-ethereum"
  machine_type = "e2-standard-4"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = "default"
    access_config {
    }
  }

  metadata = {
    ssh-keys = "ethereum:${file(var.ssh_public_key_file)}"
  }
}

resource "google_compute_firewall" "default" {
 name    = "wireguard"
 network = "default"

 allow {
   protocol = "udp"
   ports    = ["0-65535"]
 }
}
