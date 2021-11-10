variable "global_settings" {}
variable "resource_group_name" {}
variable "location" {}
variable "target_resource_id" {}
variable "monitor_autoscale_settings" {
  type = any
  description = "The map from the monitor_autoscale_settings module configuration"
}
variable "settings" {
  description = "Configuration object for the monitor autoscale setting resource"
}
