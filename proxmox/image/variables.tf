variable "proxmox_endpoint" {
  type        = string
  description = "The HTTPS URL for the Proxmox VE API"
  default     = "https://192.168.1.60:8006/"
}

variable "proxmox_api_token" {
  type        = string
  description = "The full API token string (username@realm!token_id=secret_uuid)"
  sensitive   = true # Prevents the token from being leaked in standard console outputs
}

variable "node_name" {
  type        = string
  description = "The Proxmox node where the image is downloaded"
  default     = "devops2"
}

variable "datastore_id" {
  type        = string
  description = "The datastore where the image is stored"
  default     = "local"
}

variable "image_url" {
  type        = string
  description = "The URL of the cloud image to download"
  default     = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
}

variable "image_file_name" {
  type        = string
  description = "The file name to store the image as (must end in .qcow2 for import)"
  default     = "jammy-server-cloudimg-amd64.qcow2"
}
