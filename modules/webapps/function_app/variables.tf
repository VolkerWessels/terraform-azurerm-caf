variable "settings" {}

variable "global_settings" {}

variable "location" {
  description = "(Required) Resource Location"
  default     = null
}
variable "resource_group_name" {
  description = "Resource group object to deploy the virtual machine"
  default     = null
}
variable "resource_group" {
  description = "Resource group object to deploy the virtual machine"
}

variable "tags" {
  default = null
}

variable "app_service_plan_id" {
}

variable "name" {
  description = "(Required) Name of the App Service"
}


variable "storage_account_access_key" {
  default = null
}

variable "storage_account_name" {
  default = null
}

variable "identity" {
  default = null
}

variable "connection_strings" {
  default = {}
}

variable "app_settings" {
  default = null
}

variable "slots" {
  default = {}
}

variable "application_insight" {
  default = null
}

variable "base_tags" {
  description = "Base tags for the resource to be inherited from the resource group."
  type        = bool
}

variable "combined_objects" {
  default = {}
}

variable "client_config" {}

variable "dynamic_app_settings" {
  default = {}
}

variable "remote_objects" {
  default = null
}

variable "external_app_settings" {}
variable "vnets" {}
variable "subnet_id" {}
variable "private_endpoints" {}
variable "private_dns" {}