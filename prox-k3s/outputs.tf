
output "nodes" {
  value = { for k, v in proxmox_virtual_environment_vm.nodes : k => v.initialization[0].ip_config[0].ipv4[0].address }
}

output "primary_ip" {
  value = var.nodes[local.first_node_key].ip
}

output "id" {
  value = { for k, v in proxmox_virtual_environment_vm.nodes : k => v.id }
}
