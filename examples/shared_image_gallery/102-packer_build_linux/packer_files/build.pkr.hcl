source "azure-arm" "mybuild" {
  build_resource_group_name              = var.build_resource_group_name
  client_id                              = var.client_id
  client_secret                          = var.client_secret
  image_offer                            = var.image_offer
  image_publisher                        = var.image_publisher
  image_sku                              = var.image_sku
  managed_image_name                     = var.managed_image_name
  managed_image_resource_group_name      = var.managed_image_resource_group_name
  managed_image_storage_account_type     = var.managed_image_storage_account_type
  os_type                                = var.os_type
  private_virtual_network_with_public_ip = var.private_virtual_network_with_public_ip
  subscription_id                        = var.subscription_id
  tenant_id                              = var.tenant_id
  user_assigned_managed_identities       = var.managed_identity
  virtual_network_name                   = var.virtual_network_name
  virtual_network_subnet_name            = var.virtual_network_subnet_name
  vm_size                                = var.vm_size
  azure_tags                             = local.azure_tags
}

build {
  sources = ["source.azure-arm.mybuild"]

  provisioner "ansible" {
    playbook_file = var.ansible_playbook_path
  }

}

locals {
 azure_tags = try(convert(var.azure_tags, map(string)), null)
}

variable "subscription_id" {}
variable "tenant_id"{}
variable "client_id" {}
variable "azure_tags" {
  default = null
}
variable "location" {}
variable "client_secret" {}
variable "build_resource_group_name" {
  default = null
}
variable "image_offer" {
  default = null
}
variable "image_publisher" {
  default = null
}
variable "image_sku" {
  default = null
}
variable "ansible_playbook_path" {
  default = null
}
variable "managed_image_name" {}
variable "managed_image_resource_group_name" {}
variable "managed_image_storage_account_type" {}
variable "os_type" {}
variable "private_virtual_network_with_public_ip" {
  default - null
}
variable "managed_identity" {
  default = null
}
variable "virtual_network_name" {
  default = null
}
variable "virtual_network_subnet_name" {
  default = null
}
variable "vm_size" {}
#destination sig
variable "gallery_name" {}
variable "image_name" {}
variable "image_version" {}
variable "replication_regions" {}
variable "resource_group" {}
variable "subscription" {}
variable "storage_account_type" {}
#source sig
variable "source_subscription" {
  default = null
}
variable "source_resource_group" {
  default = null
}
variable "source_gallery_name" {
  default = null
}
variable "source_image_version" {
  default = null
}