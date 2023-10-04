terraform {
  required_providers {
    azurecaf = {
      source = "aztfmod/azurecaf"
    }
  }
}

locals {
  module_tag = {
    "module" = basename(abspath(path.module))
  }
  tags = var.base_tags ? merge(
    var.global_settings.tags,
    try(var.resource_group.tags, null),
    local.module_tag,
    try(var.tags, null)
    ) : merge(
    local.module_tag,
    try(var.tags,
    null)
  )
  resource_group_name = coalesce(var.resource_group_name, var.resource_group.name)
  storage_account  = var.storage_accounts[try(var.settings.lz_key, var.settings.storage_account.lz_key, var.client_config.landingzone_key)][try(var.settings.storage_account.key, var.settings.storage_account_key)]
  app_service_plan = var.app_service_plans[try(var.settings.app_service_plan.lz_key, var.settings.lz_key, var.client_config.landingzone_key)][try(var.settings.app_service_plan.key, var.settings.app_service_plan_key)]
  app_settings     = var.external_app_settings == true ? null : try(var.app_settings, null)
  subnet_id        = can(var.settings.vnet_integration.subnet_id) || can(var.settings.vnet_integration.subnet_key) == false ? try(var.settings.vnet_integration.subnet_id, null) : var.subnets[try(var.settings.vnet_integration.lz_key, var.client_config.landingzone_key)][var.settings.vnet_integration.vnet_key].subnets[var.settings.vnet_integration.subnet_key].id
}
