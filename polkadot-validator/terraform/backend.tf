terraform {
  backend "s3" {
    bucket = "syntropy-polkadot-terraform-backend"
    key    = "network/terraform.tfstate"
    region = "us-east-1"
  }

  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
    }

    aws = {
      source = "hashicorp/aws"
    }
  }
  required_version = ">= 0.13, < 0.14"
}
