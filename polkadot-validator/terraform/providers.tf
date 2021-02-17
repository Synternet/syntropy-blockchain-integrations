provider "aws" {
  region                  = var.location
  profile                 = var.aws_profile
  shared_credentials_file = var.aws_creds_file
  version                 = "~>2.28"
}

provider "digitalocean" {
  token = var.do_token
}
