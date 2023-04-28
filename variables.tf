variable "instance_count" {
  description = "Yandex Cloud Compute instance count"
  type        = number
  default     = 1
}

variable "platform_id" {
  description = "The type of virtual machine to create"
  type        = string
  default     = "standard-v3"
}

variable "folder_id" {
  description = "Yandex Cloud Folder ID where resources will be created"
  type        = string
}

variable "image_family" {
  description = "Yandex Cloud Compute Image family"
  type        = string
}

# Preemtible VM: https://cloud.yandex.ru/docs/compute/concepts/preemptible-vm
variable "preemptible" {
  description = "Specifies if the instance is preemptible"
  type        = bool
  default     = false
}

variable "type" {
  description = "Type of the boot disk"
  type        = string
  default     = "network-ssd"
}

variable "size" {
  description = "Size of the boot disk in GB"
  type        = string
  default     = "10"
}

variable "cores" {
  description = "CPU cores for the instance"
  type        = number
  default     = 2
}

variable "memory" {
  description = "Memory size for the instance in GB"
  type        = number
  default     = 2
}

variable "core_fraction" {
  description = "Baseline performance for a core as a percent"
  type        = number
  default     = 100
}

# IP address should be already reserved in web UI
variable "nat_ip_address" {
  description = "Public IP address for instance to access the internet over NAT"
  type        = string
  default     = ""
}

variable "ip_address" {
  description = "The private IP address to assign to the instance. If empty, the address will be automatically assigned from the specified subnet"
  type        = string
  default     = ""
}

variable "ssh_username" {
  description = "User for SSH access to the instance"
  type        = string
  default     = ""
}

variable "ssh_pubkey" {
  description = "SSH public key for access to the instance"
  type        = string
  default     = ""
}

variable "secondary_disk" {
  description = "Additional secondary disk to attach to the instance"
  type        = map(map(string))
  default     = {}
}

variable "serial-port-enable" {
  description = "Serial-port-enable parameter for metadata"
  type        = number
  default     = null
}

variable "labels" {
  description = "A set of key/value label pairs to assign to the instance."
  type        = map(string)
  default     = {}
}

variable "instance" {
  description = "A map containing a map object for each value"
  type = map(object({
    name      = string # Yandex Cloud Compute instance name
    zone      = string # Yandex Cloud Zone for provision resources
    subnet_id = string # Yandex VPC subnet_id
    is_nat    = bool   # Provide a public address for instance to access the internet over NAT
  }))

  default = {}
}

# https://cloud.yandex.com/en/docs/compute/concepts/vm-metadata
variable "cloud-init-file" {
  description = "Path to cloud-init file. For example: create your user with ssh key"
  type        = string
  default     = ""
}
