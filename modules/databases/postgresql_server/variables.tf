variable "global_settings" {
  description = "Global settings object (see module README.md)"
}
variable "client_config" {
  description = "Client configuration object (see module README.md)."
}
variable "settings" {}
variable "keyvault_id" {}
variable "storage_accounts" {}
variable "azuread_groups" {}
variable "vnets" {}
variable "subnet_id" {}
variable "private_endpoints" {}
variable "diagnostic_profiles" {
  default = {}
}
variable "network_security_group_definition" {
  default = null
}
variable "diagnostics" {
  default = {}
}
variable "private_dns" {
  default = {}
}