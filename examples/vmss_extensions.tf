module "vmss_extension_microsoft_azure_domainjoin" {
  source     = "../modules/compute/virtual_machine_scale_set_extensions"
  depends_on = [module.example]

  for_each = {
    for key, value in try(var.virtual_machine_scale_sets, {}) : key => value
    if try(value.virtual_machine_scale_set_extensions.microsoft_azure_domainjoin, null) != null
  }

  client_config                = module.example.client_config
  virtual_machine_scale_set_id = module.example.virtual_machine_scale_sets[each.key].id
  extension                    = each.value.virtual_machine_scale_set_extensions.microsoft_azure_domainjoin
  extension_name               = "microsoft_azure_domainJoin"
  keyvaults                    = tomap({ (var.landingzone.key) = module.example.keyvaults })
}

module "vmss_extension_custom_scriptextension" {
  source     = "../modules/compute/virtual_machine_scale_set_extensions"
  depends_on = [module.example]

  for_each = {
    for key, value in try(var.virtual_machine_scale_sets, {}) : key => value
    if try(value.virtual_machine_scale_set_extensions.custom_script, null) != null
  }

  client_config                     = module.example.client_config
  virtual_machine_scale_set_id      = module.example.virtual_machine_scale_sets[each.key].id
  extension                         = each.value.virtual_machine_scale_set_extensions.custom_script
  extension_name                    = "custom_script"
  managed_identities                = tomap({ (var.landingzone.key) = module.example.managed_identities })
  storage_accounts                  = tomap({ (var.landingzone.key) = module.example.storage_accounts })
  virtual_machine_scale_set_os_type = module.example.virtual_machine_scale_sets[each.key].os_type
}

module "vmss_extension_keyvault_extension" {
  # source  = "../modules/compute/virtual_machine_scale_set_extensions"
  # version = "5.5.1"

  source = "git::https://github.com/VolkerWessels/terraform-azurerm-caf.git//modules/compute/virtual_machine_scale_set_extensions?ref=vw-combined"

  depends_on = [module.example]

  for_each = {
    for key, value in try(var.virtual_machine_scale_sets, {}) : key => value
    if try(value.virtual_machine_scale_set_extensions.microsoft_azure_keyvault, null) != null
  }

  client_config                = module.example.client_config
  virtual_machine_scale_set_id = module.example.virtual_machine_scale_sets[each.key].id
  extension                    = each.value.virtual_machine_scale_set_extensions.microsoft_azure_keyvault
  extension_name               = "microsoft_azure_keyvault"
  managed_identities           = tomap({ (var.landingzone.key) = module.example.managed_identities })
}

module "vmss_extension_application_health_extension" {
  # source  = "../modules/compute/virtual_machine_scale_set_extensions"
  # version = "5.5.1"

  source = "git::https://github.com/VolkerWessels/terraform-azurerm-caf.git//modules/compute/virtual_machine_scale_set_extensions?ref=vw-combined"

  depends_on = [module.example]

  for_each = {
    for key, value in try(var.virtual_machine_scale_sets, {}) : key => value
    if try(value.virtual_machine_scale_set_extensions.microsoft_azure_health_extension, null) != null
  }

  client_config                     = module.example.client_config
  virtual_machine_scale_set_id      = module.example.virtual_machine_scale_sets[each.key].id
  virtual_machine_scale_set_os_type = module.example.virtual_machine_scale_sets[each.key].os_type
  extension                         = each.value.virtual_machine_scale_set_extensions.microsoft_azure_health_extension
  extension_name                    = "microsoft_azure_health_extension"
}
