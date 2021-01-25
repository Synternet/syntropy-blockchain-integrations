resource "local_file" "ansible_inventory" {
  content = templatefile("ansible_inventory.tmpl", {
    nomad_server_ip  = module.nomad_cluster.server_ip,
    nomad_client_ips = module.nomad_cluster.client_ips
  })
  filename = "../ansible/inventory.yml"
}
