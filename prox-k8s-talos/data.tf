data "talos_machine_configuration" "control_plane" {
  cluster_name     = var.cluster_name
  cluster_endpoint = var.cluster_endpoint
  machine_type     = "controlplane"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
  talos_version    = var.talos_version

  config_patches = [
    yamlencode({
      machine = {
        network = {
          interfaces = var.control_plane_vip == null ? [] : [
            {
              interface = "eth0"
              vip = {
                ip = var.control_plane_vip
              }
            }
          ]
          nameservers = var.nameservers
        }
        features = {
          hostDNS = {
            enabled              = true
            resolveMemberNames   = true
            forwardKubeDNSToHost = false
          }
        }
      }
      cluster = {
        network = {
          cni = {
            name = "flannel"
          }
        }
      }
    })
  ]
}

data "talos_machine_configuration" "worker" {
  cluster_name     = var.cluster_name
  cluster_endpoint = var.cluster_endpoint
  machine_type     = "worker"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
  talos_version    = var.talos_version

  config_patches = [
    yamlencode({
      machine = {
        network = {
          nameservers = var.nameservers
        }
        features = {
          hostDNS = {
            enabled              = true
            resolveMemberNames   = true
            forwardKubeDNSToHost = false
          }
        }
      }
      cluster = {
        network = {
          cni = {
            name = "flannel"
          }
        }
      }
    })
  ]
}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints            = [for k, v in var.control_plane_nodes : v.ip]
}
