data "azurerm_key_vault_secret" "packer_client_id" {
  name         = format("%s-client-id", var.settings.secret_prefix)
  key_vault_id = var.key_vault_id
}

data "azurerm_key_vault_secret" "packer_secret" {
  name         = format("%s-client-secret", var.settings.secret_prefix)
  key_vault_id = var.key_vault_id
}

resource "local_file" "packer_var_file" {
  content = jsonencode(
    {
      client_id                              = data.azurerm_key_vault_secret.packer_client_id.value
      client_secret                          = data.azurerm_key_vault_secret.packer_secret.value
      tenant_id                              = var.tenant_id
      subscription_id                        = var.subscription
      os_type                                = var.settings.os_type
      image_publisher                        = var.settings.image_publisher
      image_offer                            = var.settings.image_offer
      image_sku                              = var.settings.image_sku
      location                               = var.location
      vm_size                                = var.settings.vm_size
      managed_image_resource_group_name      = var.resource_group_name
      build_resource_group_name              = var.build_resource_group_name
      virtual_network_name                   = try(var.vnet_name, null)
      virtual_network_subnet_name            = try(var.subnet_name, null)
      private_virtual_network_with_public_ip = try(var.settings.private_virtual_network_with_public_ip, null)
      managed_image_storage_account_type     = try(var.settings.managed_image_storage_account_type, null)
      storage_account_type                   = try(var.settings.storage_account_type, null)
      managed_image_name                     = local.managed_image_name
      build_script                           = try(var.settings.build_script, null)
      managed_identity                       = local.managed_identity
      azure_tags                             = try(var.settings.tag_packer_resources, false) == true ? local.tags : null
      //shared_image_gallery destination values. If publishing to a different Subscription, change the following arguments and supply the values as variables
      subscription                                     = var.subscription
      resource_group                                   = var.resource_group_name
      gallery_name                                     = var.gallery_name
      image_name                                       = var.image_name
      image_version                                    = local.image_version
      replication_regions                              = var.settings.shared_image_gallery_destination.replication_regions
      shared_gallery_image_version_exclude_from_latest = try(var.settings.shared_gallery_image_version_exclude_from_latest, null)
      packer_working_dir                               = var.settings.packer_working_dir
      //source shared_image_gallery values
      # source_subscription   = try(var.settings.source_subscription, null)
      # source_resource_group = try(var.settings.source_resource_group, null)
      # source_gallery_name   = try(var.settings.source_gallery_name, null)
      # source_image_version  = try(var.settings.source_image_version, null)
    }
  )
  filename             = local.packer_var_filepath
  file_permission      = "0640"
  directory_permission = "0755"
}

resource "null_resource" "create_image" {
  triggers = {
    build_trigger = local.build_trigger
  }
  provisioner "local-exec" {
    command = "packer init ${local.packer_template_filepath} && packer build -force -var-file ${local.packer_var_filepath} ${local.packer_template_filepath}"
  }
  depends_on = [
    local_file.packer_var_file
  ]
}

data "external" "image_versions" { # data source errors if no versions exist
  program = [
    "bash", "-c",
    format(
      "a=$(az sig image-version list --resource-group %s --gallery-name %s --gallery-image-definition %s -o json --query 'max_by([].{name:name},&name)'); if [[ $a == *name* ]]; then echo $a; else echo '{ \"name\":\"0.0.0\" }'; fi",
      var.resource_group_name, var.gallery_name, var.image_name
    )
  ]
}

resource "null_resource" "delete_image" {
  count = try(var.settings.keep_image, false) == true ? 0 : 1
  triggers = {
    build_trigger    = local.build_trigger
    managed_image_id = local.managed_image_id
  }
  provisioner "local-exec" {
    when        = create
    interpreter = ["/bin/bash"]
    command     = format("%s/destroy_image.sh", path.module)
    on_failure  = fail
    environment = {
      RESOURCE_IDS = self.triggers.managed_image_id
    }
  }
  depends_on = [
    null_resource.create_image
  ]
}

resource "time_sleep" "time_delay_3" {
  triggers = {
    build_trigger = local.build_trigger
  }
  create_duration = "40s"
  depends_on = [
    null_resource.delete_image
  ]
}

# resource "null_resource" "exclude_from_latest" {
#   triggers = {
#     exclude_from_latest = var.settings.shared_gallery_image_version_exclude_from_latest
#   }
#   provisioner "local-exec" {
#     command = format("az sig image-version update --resource-group %s --gallery-name %s --gallery-image-definition %s --gallery-image-version %s --set publishingProfile.excludeFromLatest=%t ||true",
#       var.resource_group_name, var.gallery_name, var.image_name, local.image_version, var.settings.shared_gallery_image_version_exclude_from_latest
#     )
#   }
# }

resource "null_resource" "clean_old_versions" {
  triggers = {
    build_trigger = local.build_trigger
  }
  provisioner "local-exec" {
    command = format("versions=$(az sig image-version list --resource-group %s --gallery-name %s --gallery-image-definition %s --query 'sort_by([].{name:name},&name) | [:-%d]' -o tsv)  && if [[ $(expr length $versions) -gt 0 ]]; then az sig image-version delete --resource-group %s --gallery-name %s --gallery-image-definition %s --gallery-image-version $versions; fi",
      var.resource_group_name, var.gallery_name, var.image_name, var.settings.keep_versions, var.resource_group_name, var.gallery_name, var.image_name
    )
  }
  depends_on = [
    null_resource.create_image
  ]
}

data "azurerm_platform_image" "source" {
  count     = try(var.settings.image_publisher, "") == "" ? 0 : 1
  publisher = var.settings.image_publisher
  offer     = var.settings.image_offer
  sku       = var.settings.image_sku
  location  = var.settings.location
}

# data "azurerm_shared_image_version" "source" {
#   count = try(var.settings.source_gallery_name, "") == "" ? 0 : 1
#   name = var.settings.source_image_version
#   image_name = var.settings.source
#    source_gallery_name
# }

locals {
  packer_template_filepath     = "${var.settings.packer_working_dir}${var.settings.packer_template_file}"
  packer_var_filepath          = "${var.settings.packer_working_dir}${var.settings.packer_var_file}"
  build_trigger                = md5("${filemd5(local.packer_template_filepath)}${var.settings.managed_image_name}${try(data.azurerm_platform_image.source[0].id, "")}")
  managed_image_id             = try("/subscriptions/${var.subscription}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Compute/images/${var.settings.managed_image_name}", "")
  managed_image_name           = format("%s-%s", var.settings.managed_image_name, local.image_version)
  highest_version_number       = data.external.image_versions.result.name
  next_version_number          = tonumber(element(split(".", local.highest_version_number), 2)) + 1
  image_version                = format("%s.%s.%s", "0", "0", tostring(local.next_version_number))
  # managed identity
  managed_local_identity       = try(var.managed_identities[var.client_config.landingzone_key][var.settings.managed_identity_key].id, "")
  managed_remote_identity      = try(var.managed_identities[var.settings.lz_key][var.settings.managed_identity_key].id, "")
  provided_identity            = try(var.settings.managed_identity_id, "")
  managed_identity             = try(merge(local.managed_local_identity, local.managed_remote_identity, local.provided_identity), [])
  #existing_image_versions      = local.image_version == "0.0.1" ? [] : data.azurerm_shared_image_versions.versions.images
  #existing_image_versions_list = sort(local.existing_image_versions[*].name)
 # image_versions_to_delete     = try(slice(local.existing_image_versions_list, 0, length(local.existing_image_versions_list) - var.settings.keep_versions), [])
}