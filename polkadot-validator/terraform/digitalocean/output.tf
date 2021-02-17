

output "droplet_monitoring_ip" {
  value = digitalocean_droplet.syntropy-polkadot-monitoring.ipv4_address
}
