output "server_ip" {
  value = aws_instance.nomad_server.public_ip
}

output "client_ips" {
  value = aws_instance.nomad_clients.*.public_ip
}