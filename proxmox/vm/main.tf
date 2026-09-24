data "proxmox_file" "ubuntu_cloud_image" {
  node_name    = var.node_name
  datastore_id = var.image_datastore_id
  content_type = "import"
  file_name    = var.image_file_name
}

resource "proxmox_virtual_environment_vm" "ubuntu_vm" {
  name      = "${var.vm_name}-${each.key}"
  node_name = var.node_name

  # should be true if qemu agent is not installed / enabled on the VM
  stop_on_destroy = true
  for_each        = var.ip_address

  initialization {
    user_account {
      # do not use this in production, configure your own ssh key instead!
      username = var.user
      password = var.pass
    }
    dns {
      servers = var.dns_servers
    }
    ip_config {
      ipv4 {
        address = each.value
        gateway = var.gateway
      }
    }
  }

  disk {
    datastore_id = "local-lvm"
    import_from  = data.proxmox_file.ubuntu_cloud_image.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 50
  }

  cpu {
    cores = 4
  }
  memory {
    dedicated = "4096"
  }
  network_device {
    bridge = "vmbr1"
  }
}
