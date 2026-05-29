output "talos_config" {
  value     = data.talos_client_configuration.this.talos_config
  sensitive = true
}

output "kubeconfig_raw" {
  value     = talos_cluster_kubeconfig.this.kubeconfig_raw
  sensitive = true
}

output "talos_schematic_id" {
  value       = talos_image_factory_schematic.this.id
  description = "The Talos Image Factory schematic ID"
}

output "talos_image_url" {
  value       = "https://factory.talos.dev/image/${talos_image_factory_schematic.this.id}/${var.talos_version}/nocloud-amd64.raw.gz"
  description = "The full URL for the Talos ISO/Image"
}

output "talos_version" {
  value       = var.talos_version
  description = "The Talos version currently configured"
}
