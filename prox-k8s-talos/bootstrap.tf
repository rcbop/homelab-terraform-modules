resource "talos_machine_secrets" "this" {}

resource "talos_machine_configuration_apply" "control_plane" {
  for_each = proxmox_virtual_environment_vm.talos_control_plane

  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.control_plane.machine_configuration
  node                        = var.control_plane_nodes[each.key].ip
  config_patches = concat(
    [
      yamlencode({
        machine = {
          nodeLabels = {
            "topology.kubernetes.io/region" = var.node_region
            "topology.kubernetes.io/zone"   = var.control_plane_nodes[each.key].target_node
          }
          network = {
            interfaces = [
              merge({
                interface = var.control_plane_nodes[each.key].interface_name
                addresses = ["${var.control_plane_nodes[each.key].ip}/24"]
                routes = [
                  {
                    network = "0.0.0.0/0"
                    gateway = var.network_gateway
                  }
                ]
                },
                var.control_plane_vip != null && try(var.control_plane_nodes[each.key].vip_enabled, true) ? {
                  vip = {
                    ip = var.control_plane_vip
                  }
                } : {}
              )
            ]
            nameservers = var.nameservers
          }
          registries = {
            mirrors = var.registry_mirrors
          }
        }
      })
    ]
  )
}

resource "talos_machine_configuration_apply" "worker" {
  for_each = proxmox_virtual_environment_vm.talos_worker

  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker.machine_configuration
  node                        = var.worker_nodes[each.key].ip
  config_patches = concat(
    [
      yamlencode({
        machine = {
          nodeLabels = {
            "topology.kubernetes.io/region"        = var.node_region
            "topology.kubernetes.io/zone"          = var.worker_nodes[each.key].target_node
            "node.longhorn.io/create-default-disk" = try(var.worker_nodes[each.key].longhorn_data_disk.enabled, false) ? "true" : "false"
          }
          kubelet = try(var.worker_nodes[each.key].longhorn_data_disk.enabled, false) ? {
            extraMounts = [
              {
                destination = "/var/mnt/longhorn"
                type        = "bind"
                source      = "/var/mnt/longhorn"
                options     = ["bind", "rshared", "rw"]
              }
            ]
          } : null
          network = {
            interfaces = [
              {
                interface = var.worker_nodes[each.key].interface_name
                addresses = ["${var.worker_nodes[each.key].ip}/24"]
                routes = [
                  {
                    network = "0.0.0.0/0"
                    gateway = var.network_gateway
                  }
                ]
              }
            ]
            nameservers = var.nameservers
          }
          registries = {
            mirrors = var.registry_mirrors
          }
        }
      })
    ],
    try(var.worker_nodes[each.key].longhorn_data_disk.enabled, false) ? [
      yamlencode({
        apiVersion = "v1alpha1"
        kind       = "UserVolumeConfig"
        name       = "longhorn"
        provisioning = {
          diskSelector = {
            match = "disk.size > 240u * GB && disk.size < 270u * GB && !system_disk"
          }
          grow    = false
          minSize = try(var.worker_nodes[each.key].longhorn_data_disk.min_size, "200GB")
          maxSize = try(var.worker_nodes[each.key].longhorn_data_disk.max_size, "250GB")
        }
        filesystem = {
          type = "xfs"
        }
      })
    ] : [],
    length(var.worker_nodes[each.key].pci_devices) > 0 ? [
      yamlencode({
        machine = {
          install = {
            extraKernelArgs = [
              "i915.enable_dc=0",
              "i915.enable_guc=3"
            ]
          }
        }
      })
    ] : []
  )
}

resource "talos_machine_bootstrap" "this" {
  depends_on = [talos_machine_configuration_apply.control_plane]

  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = var.control_plane_nodes[keys(var.control_plane_nodes)[0]].ip
}

resource "talos_cluster_kubeconfig" "this" {
  depends_on = [talos_machine_bootstrap.this]

  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = var.control_plane_nodes[keys(var.control_plane_nodes)[0]].ip
}
