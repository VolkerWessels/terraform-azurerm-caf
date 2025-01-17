terraform {
  required_providers {
    azurecaf = {
      source = "aztfmod/azurecaf"
    }
  }

}

locals {
  location            = can(var.settings.location) ? var.settings.location : var.remote_objects.resource_groups[try(var.settings.resource_group.lz_key, var.client_config.landingzone_key)][var.settings.resource_group.key].location
  resource_group_name = can(var.settings.resource_group_name) || can(var.settings.resource_group.name) ? try(var.settings.resource_group_name, var.settings.resource_group.name) : var.remote_objects.resource_groups[try(var.settings.resource_group.lz_key, var.client_config.landingzone_key)][var.settings.resource_group.key].name
  base_tags           = can(var.settings.base_tags) ?  var.settings.base_tags : try(var.global_settings.inherit_tags, false)
  tags = local.base_tags ? merge(
    var.global_settings.tags,
    try(var.settings.tags, null)
  ) : try(var.settings.tags, null)
}