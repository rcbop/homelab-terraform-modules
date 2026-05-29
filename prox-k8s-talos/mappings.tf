resource "proxmox_virtual_environment_hardware_mapping_pci" "igpu_atlas" {
  name             = "igpu-atlas"
  mediated_devices = false

  map = [{
    id           = "8086:3e92"
    node         = "atlas"
    path         = "0000:00:02.0"
    subsystem_id = "103c:8594"
    iommu_group  = 0
  }]
}
