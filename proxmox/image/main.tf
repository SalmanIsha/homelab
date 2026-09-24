resource "proxmox_download_file" "ubuntu_cloud_image" {
  content_type = "import"
  datastore_id = var.datastore_id
  node_name    = var.node_name
  url          = var.image_url
  # need to rename the file to *.qcow2 to indicate the actual file format for import
  file_name = var.image_file_name
}
