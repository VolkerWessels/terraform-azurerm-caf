data "azurerm_key_vault_secret" "packer_client_id" {
  name         = format("%s-client-id", var.settings.secret_prefix)
  key_vault_id = var.key_vault_id
}

data "azurerm_key_vault_secret" "packer_secret" {
  name         = format("%s-client-secret", var.settings.secret_prefix)
  key_vault_id = var.key_vault_id
}

# resource "local_file" "packer_template" {
#   content = templatefile(var.settings.packer_template_filepath,
#     {
#       client_id                         = data.azurerm_key_vault_secret.packer_client_id.value
#       client_secret                     = data.azurerm_key_vault_secret.packer_secret.value
#       tenant_id                         = var.tenant_id
#       subscription_id                   = var.subscription
#       os_type                           = var.settings.os_type
#       image_publisher                   = var.settings.image_publisher
#       image_offer                       = var.settings.image_offer
#       image_sku                         = var.settings.image_sku
#       location                          = var.location
#       vm_size                           = var.settings.vm_size
#       managed_image_resource_group_name = var.resource_group_name
#       build_resource_group_name         = var.build_resource_group_name
#       #virtual_network_name = try(try(var.settings.vnet_name, null) != null ? var.settings.vnet_name : try(var.vnets[var.client_config.landingzone_key][var.settings.vnet_key].name, var.vnets[var.settings.lz_key][var.settings.vnet_key].name), "")
#       #virtual_network_subnet_name = try(try(var.settings.subnet_name, null) != null ? var.settings.subnet_name : try(var.vnets[var.client_config.landingzone_key][var.settings.vnet_key].subnets[var.settings.subnet_key].name, var.vnets[var.settings.lz_key][var.settings.vnet_key].subnets[var.settings.subnet_key].name), "")
#       virtual_network_name              = try(var.vnet_name, "")
#       virtual_network_subnet_name       = try(var.subnet_name, "")

#       managed_image_name    = var.settings.managed_image_name
#       ansible_playbook_path = var.settings.ansible_playbook_path
#       managed_identity = local.managed_identity

#       //shared_image_gallery destination values. If publishing to a different Subscription, change the following arguments and supply the values as variables
#       subscription        = var.subscription
#       resource_group      = var.resource_group_name
#       gallery_name        = var.gallery_name
#       image_name          = var.image_name
#       image_version       = var.settings.shared_image_gallery_destination.image_version
#       replication_regions = var.settings.shared_image_gallery_destination.replication_regions
#     }
#   )
#   filename             = var.settings.packer_template_filepath
#   file_permission      = "0640"
#   directory_permission = "0755"
# }

# resource "local_file" "template" {
#   content = <<-EOT
#     %%{ for config_key, config_value in config }
#     $${config_key} = "$${config_value}"
#     %%{ endfor ~}
#   EOT
#   filename             = var.settings.packer_template_filepath
#   file_permission      = "0640"
#   directory_permission = "0755"
# }

# resource "local_file" "azure_tags" {
#   content = templatefile(var.settings.azure_tags_filepath, local.tags)
#   filename             = var.settings.azure_tags_filepath
#   file_permission      = "0640"
#   directory_permission = "0755"
# }

# resource "local_file" "packer_template" {
#   content = templatefile(var.settings.packer_template_filepath, 
#     { 
#       config = {
#       client_id                         = data.azurerm_key_vault_secret.packer_client_id.value
#       client_secret                     = data.azurerm_key_vault_secret.packer_secret.value
#       tenant_id                         = var.tenant_id
#       subscription_id                   = var.subscription
#       os_type                           = var.settings.os_type
#       image_publisher                   = var.settings.image_publisher
#       image_offer                       = var.settings.image_offer
#       image_sku                         = var.settings.image_sku
#       location                          = var.location
#       vm_size                           = var.settings.vm_size
#       managed_image_resource_group_name = var.resource_group_name
#       build_resource_group_name         = var.build_resource_group_name
#       #virtual_network_name = try(try(var.settings.vnet_name, null) != null ? var.settings.vnet_name : try(var.vnets[var.client_config.landingzone_key][var.settings.vnet_key].name, var.vnets[var.settings.lz_key][var.settings.vnet_key].name), "")
#       #virtual_network_subnet_name = try(try(var.settings.subnet_name, null) != null ? var.settings.subnet_name : try(var.vnets[var.client_config.landingzone_key][var.settings.vnet_key].subnets[var.settings.subnet_key].name, var.vnets[var.settings.lz_key][var.settings.vnet_key].subnets[var.settings.subnet_key].name), "")
#       virtual_network_name              = try(var.vnet_name, "")
#       virtual_network_subnet_name       = try(var.subnet_name, "")

#       managed_image_name    = var.settings.managed_image_name
#       ansible_playbook_path = var.settings.ansible_playbook_path
#       managed_identity = local.managed_identity

#       //shared_image_gallery destination values. If publishing to a different Subscription, change the following arguments and supply the values as variables
#       subscription        = var.subscription
#       resource_group      = var.resource_group_name
#       gallery_name        = var.gallery_name
#       image_name          = var.image_name
#       image_version       = var.settings.shared_image_gallery_destination.image_version
#       replication_regions = var.settings.shared_image_gallery_destination.replication_regions
#       }
#     }
#   )
#   filename             = var.settings.packer_template_filepath
#   file_permission      = "0640"
#   directory_permission = "0755"
# }

resource "local_file" "packer_template" {
  content = jsonencode(
    { 
    client_id                         = data.azurerm_key_vault_secret.packer_client_id.value
    client_secret                     = data.azurerm_key_vault_secret.packer_secret.value
    tenant_id                         = var.tenant_id
    subscription_id                   = var.subscription
    os_type                           = var.settings.os_type
    image_publisher                   = var.settings.image_publisher
    image_offer                       = var.settings.image_offer
    image_sku                         = var.settings.image_sku
    location                          = var.location
    vm_size                           = var.settings.vm_size
    managed_image_resource_group_name = var.resource_group_name
    build_resource_group_name         = var.build_resource_group_name
    #virtual_network_name = try(try(var.settings.vnet_name, null) != null ? var.settings.vnet_name : try(var.vnets[var.client_config.landingzone_key][var.settings.vnet_key].name, var.vnets[var.settings.lz_key][var.settings.vnet_key].name), "")
    #virtual_network_subnet_name = try(try(var.settings.subnet_name, null) != null ? var.settings.subnet_name : try(var.vnets[var.client_config.landingzone_key][var.settings.vnet_key].subnets[var.settings.subnet_key].name, var.vnets[var.settings.lz_key][var.settings.vnet_key].subnets[var.settings.subnet_key].name), "")
    virtual_network_name              = try(var.vnet_name, "")
    virtual_network_subnet_name       = try(var.subnet_name, "")

    managed_image_name    = var.settings.managed_image_name
    ansible_playbook_path = var.settings.ansible_playbook_path
    managed_identity = local.managed_identity

    //shared_image_gallery destination values. If publishing to a different Subscription, change the following arguments and supply the values as variables
    subscription        = var.subscription
    resource_group      = var.resource_group_name
    gallery_name        = var.gallery_name
    image_name          = var.image_name
    image_version       = var.settings.shared_image_gallery_destination.image_version
    replication_regions = var.settings.shared_image_gallery_destination.replication_regions
    azure_tags          = local.tags
    }
  )
  filename             = var.settings.packer_template_filepath
  file_permission      = "0640"
  directory_permission = "0755"
}

resource "null_resource" "create_image" {
  triggers = {
    os_type                           = var.settings.os_type
    image_publisher                   = var.settings.image_publisher
    image_offer                       = var.settings.image_offer
    image_sku                         = var.settings.image_sku
    image_name          = var.image_name
    image_version       = var.settings.shared_image_gallery_destination.image_version
    managed_image_name    = var.settings.managed_image_name
    #build = filemd5(var.settings.packer_config_filepath)
  }
  provisioner "local-exec" {
    command = "packer build -force -var-file ${var.settings.packer_template_filepath} ${var.settings.packer_config_filepath}"
  }
  depends_on = [
    local_file.packer_template
  ]
}

resource "azurerm_shared_image_version" "image_version" {
  name = var.settings.shared_image_gallery_destination.image_version
  gallery_name =var.gallery_name
  image_name =  var.image_name
  resource_group_name = var.resource_group_name
  location = var.location
  managed_image_id = local.managed_image_id
  #managed_image_id = data.azurerm_image.image.id
  #/subscriptions/370e92be-cdb8-4a7a-af85-e996b3706e58/resourceGroups/peob-rg-sig/providers/Microsoft.Compute/images/
  #/subscriptions/370e92be-cdb8-4a7a-af85-e996b3706e58/resourceGroups/peob-rg-sig/providers/Microsoft.Compute/galleries/peobsigtest1/images/
  #/subscriptions/370e92be-cdb8-4a7a-af85-e996b3706e58/resourceGroups/nvpm-rg-sig/providers/Microsoft.Compute/images/myImage5
  
  target_region {
    name = var.location
    regional_replica_count = 1
    storage_account_type = "Standard_LRS"
  }
  depends_on = [
    null_resource.create_image
  ]
}

// data "azurerm_image" "image" {
//   name                = var.settings.managed_image_name
// //   gallery_name        = var.gallery_name
// //  # image_name          = var.image_name
//   resource_group_name = var.resource_group_name
//   depends_on = [
//     null_resource.create_image
//   ]
// }

resource "time_sleep" "time_delay_3" {
  triggers = {
    managed_image_id = local.managed_image_id
  }
  create_duration = "60s"
  depends_on = [
    null_resource.delete_image
  ]
}

resource "null_resource" "delete_image" {
  triggers = {
    os_type                           = var.settings.os_type
    image_publisher                   = var.settings.image_publisher
    image_offer                       = var.settings.image_offer
    image_sku                         = var.settings.image_sku
    image_name          = var.image_name
    image_version       = var.settings.shared_image_gallery_destination.image_version
    managed_image_name    = var.settings.managed_image_name
    managed_image_id = local.managed_image_id
  }
  provisioner "local-exec" {
    when        = destroy
    interpreter = ["/bin/bash"]
    command     = format("%s/destroy_image.sh", path.module)
    on_failure  = fail
    environment = {
      RESOURCE_IDS = self.triggers.managed_image_id
    }
  }
  depends_on = [
    resource.azurerm_shared_image_version.image_version
  ]

}

locals {
  # managed identity
  managed_local_identity = try(var.managed_identities[var.client_config.landingzone_key][var.settings.managed_identity_key].id, "")
  managed_remote_identity = try(var.managed_identities[var.settings.lz_key][var.settings.managed_identity_key].id, "")
  provided_identity = try(var.settings.managed_identity_id, "")
  managed_identity = try(coalesce(local.managed_local_identity, local.managed_remote_identity, local.provided_identity),"")
  managed_image_id = try("/subscriptions/${var.subscription}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Compute/images/${var.settings.managed_image_name}", "")
}