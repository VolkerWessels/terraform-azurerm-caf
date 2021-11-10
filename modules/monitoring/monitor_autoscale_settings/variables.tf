variable "global_settings" {}
variable "resource_group_name" {}
variable "location" {}
variable "target_resource_id" {}
variable "settings" {
  default = {}
  description = "Configuration object for the monitor autoscale setting resource"
}
