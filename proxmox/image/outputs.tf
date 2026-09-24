output "image_file_id" {
  description = "The volume ID of the downloaded cloud image"
  value       = proxmox_download_file.ubuntu_cloud_image.id
}
