resource "talos_image_factory_schematic" "this" {
  schematic = yamlencode({
    customization = {
      systemExtensions = {
        officialExtensions = [
          "siderolabs/qemu-guest-agent",
          "siderolabs/nfs-utils",
          "siderolabs/util-linux-tools",
          "siderolabs/iscsi-tools",
          "siderolabs/intel-ucode", # hardware security
          "siderolabs/i915-ucode",  # gpu firmware
        ]
      }
    }
  })
}


resource "proxmox_virtual_environment_download_file" "talos_nocloud_image" {
  content_type            = "iso"
  datastore_id            = "nas-devops"
  node_name               = "behemoth"
  url                     = "https://factory.talos.dev/image/${talos_image_factory_schematic.this.id}/${var.talos_version}/nocloud-amd64.raw.gz"
  file_name               = "talos-${var.talos_version}-nocloud-amd64.img"
  decompression_algorithm = "gz"
  overwrite               = false
}
