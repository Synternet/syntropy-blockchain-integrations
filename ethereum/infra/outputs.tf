resource "local_file" "ansible_inventory" {
  content = templatefile("ansible_inventory.tmpl", {
    monitoring_ip  = google_compute_instance.monitoring_node.network_interface.0.access_config.0.nat_ip,
    ethereum_node_ip = linode_instance.ethereum_node.ip_address
  })
  filename = "../ansible/inventory.yml"
}
