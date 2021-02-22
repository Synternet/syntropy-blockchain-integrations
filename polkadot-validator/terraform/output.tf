resource "local_file" "ansible_inventory" {
  content = templatefile("../tpl/ansible_inventory.tmpl", {
    validator_ip  = module.aws_validator.ip_address
    monitoring_ip = module.digitalocean_monitoring.droplet_monitoring_ip
  })
  filename = "../ansible/inventory"
}
