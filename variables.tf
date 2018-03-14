variable "depends_id" {
  default = ""
}

variable "region" {
  type    = "string"
  default = ""
}

variable "can_ip_forward" {
  type    = "string"
  default = false
}

variable "base_name" {
  type = "string"
}

variable "amount" {
  type    = "string"
  default = 1
}

variable "offset" {
  type    = "string"
  default = 0
}

variable "address_offset" {
  type    = "string"
  default = 0
}

variable "address_fixed" {
  type    = "string"
  default = false
}

variable "boot_disk_type" {
  type    = "string"
  default = "pd-ssd"
}

variable "boot_disk_source_image" {
  type = "string"
}

variable "boot_disk_size" {
  type = "string"
}

variable "machine_type" {
  type = "string"
}

variable "tags" {
  type    = "list"
  default = []
}

variable "network" {
  type    = "string"
  default = "default"
}

variable "preemptible" {
  type    = "string"
  default = false
}

variable "metadata" {
  type    = "map"
  default = {}
}
