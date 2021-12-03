source "azure-arm" "mybuild" {
  build_resource_group_name              = "${build_resource_group_name}"
  client_id                              = "${client_id}"
  client_secret                          = "${client_secret}"
  image_offer                            = "${image_offer}"
  image_publisher                        = "${image_publisher}"
  image_sku                              = "${image_sku}"
  managed_image_name                     = "${managed_image_name}"
  managed_image_resource_group_name      = "${managed_image_resource_group_name}"
  managed_image_storage_account_type     = "Premium_LRS"
  os_type                                = "${os_type}"
  private_virtual_network_with_public_ip = "true"
  shared_image_gallery_destination {
    gallery_name        = "${gallery_name}"
    image_name          = "${image_name}"
    image_version       = "${image_version}"
    replication_regions = ["${replication_regions}"]
    resource_group      = "${resource_group}"
    subscription        = "${subscription_id}"
    storage_account_type = "Standard_LRS"
  }
  subscription_id                  = "${subscription_id}"
  tenant_id                        = "${tenant_id}"
  user_assigned_managed_identities = ["${managed_identity}"]
  virtual_network_name             = "${virtual_network_name}"
  virtual_network_subnet_name      = "${virtual_network_subnet_name}"
  vm_size                          = "${vm_size}"
}

# a build block invokes sources and runs provisioning steps on them. The
# documentation for build blocks can be found here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/build
build {
  sources = ["source.azure-arm.mybuild"]

  provisioner "ansible" {
    playbook_file = "${ansible_playbook_path}"
  }

}
