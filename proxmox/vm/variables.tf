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

variable "user" {
  type        = string
  description = "Username of the vm"
  default     = "devops"
}

variable "pass" {
  type        = string
  description = "Password of the vm"
  sensitive   = true
}

variable "vm_name" {
  type    = string
  default = "k3s-worker"
}

variable "node_name" {
  type    = string
  default = "devops2"
}

variable "dns_servers" {
  type    = list(string)
  default = ["10.10.3.254"]
}

variable "gateway" {
  type    = string
  default = "10.10.3.254"
}

variable "ip_address" {
  type = map(string)
  default = {
    "0" = "10.10.3.20/24"
    "1" = "10.10.3.30/24"
  }
}

variable "image_datastore_id" {
  type        = string
  description = "The datastore where the cloud image lives"
  default     = "local"
}

variable "image_file_name" {
  type        = string
  description = "The file name of the existing cloud image to import"
  default     = "jammy-server-cloudimg-amd64.qcow2"
}
