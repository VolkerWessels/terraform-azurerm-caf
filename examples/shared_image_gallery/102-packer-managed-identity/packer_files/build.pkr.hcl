variable "client_id" {}
variable "ansible_playbook_path" {}
variable "azure_tags" {}
variable "location" {}
variable "client_secret" {}
variable "build_resource_group_name" {}
variable "image_offer" {}
variable "image_publisher" {}
variable "image_sku" {}
variable "managed_image_name" {}
variable "managed_image_resource_group_name" {}
variable "managed_image_storage_account_type" {
  default = "Premium_LRS"
}
variable "os_type" {}
variable "private_virtual_network_with_public_ip" {
  default = true
}
variable "gallery_name" {}
variable "image_name" {}
variable "image_version" {}
variable "replication_regions" {}
variable "resource_group" {}
variable "subscription" {}
variable "storage_account_type" {
  default = "Premium_LRS"
}
variable "subscription_id" {}
variable "tenant_id"{}
variable "managed_identity" {}
variable "virtual_network_name" {}
variable "virtual_network_subnet_name" {}
variable "vm_size" {}

locals {
 azure_tags = convert(var.azure_tags, map(string))
}

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
  # shared_image_gallery_destination {
  #   gallery_name        = var.gallery_name
  #   image_name          = var.image_name
  #   image_version       = var.image_version
  #   replication_regions = [var.replication_regions]
  #   resource_group      = var.resource_group
  #   subscription        = var.subscription
  #   storage_account_type = var.storage_account_type
  #}
  subscription_id                  = var.subscription_id
  tenant_id                        = var.tenant_id
  user_assigned_managed_identities = [var.managed_identity]
  virtual_network_name             = var.virtual_network_name
  virtual_network_subnet_name      = var.virtual_network_subnet_name
  vm_size                          = var.vm_size
  azure_tags                       = local.azure_tags
}

# a build block invokes sources and runs provisioning steps on them. The
# documentation for build blocks can be found here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/build
build {
  sources = ["source.azure-arm.mybuild"]

  provisioner "ansible" {
    playbook_file = var.ansible_playbook_path
  }

}
