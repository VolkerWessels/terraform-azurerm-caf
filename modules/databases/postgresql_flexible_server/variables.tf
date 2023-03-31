variable "client_config" {
  description = "Client configuration object (see module README.md)."
  default     = {}
}

variable "global_settings" {
  description = "Global settings object (see module README.md)"
  default     = {}
}

variable "remote_objects" {
  description = "(Required) Specifies the supported Azure location where to create the resource. Changing this forces a new resource to be created."
  default     = {}
}

variable "settings" {
  description = "(Required) Used to handle passthrough parameters."
  default     = {}
}

variable "location" {
  description = "(Required) Specifies the supported Azure location where to create the resource. Changing this forces a new resource to be created."
  type        = string
}

variable "subnet_id" {
  default = {}
}

variable "keyvault_id" {
  default = {}
}