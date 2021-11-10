variable "virtual_machine_scale_set_id" {}
variable "extension" {}
variable "extension_name" {}
variable "client_config" {
  description = "Client configuration object (see module README.md)."
}
variable "managed_identities" {
  default = {}
}
variable "storage_accounts" {
  default = {}
}

