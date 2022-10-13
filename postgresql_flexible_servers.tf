output "postgresql_flexible_servers" {
  value = module.postgresql_flexible_servers
}

module "postgresql_flexible_servers" {
  source     = "./modules/databases/postgresql_flexible_server"
  depends_on = [module.keyvault_access_policies, module.keyvault_access_policies_azuread_apps]
  for_each   = local.database.postgresql_flexible_servers

  global_settings = local.global_settings
  client_config   = local.client_config
  settings        = each.value

  location            = can(local.global_settings.regions[each.value.region]) ? local.global_settings.regions[each.value.region] : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group.key, each.value.resource_group_key)].location
  resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group_key, each.value.resource_group.key)].name

  remote_objects = {
    vnets               = local.combined_objects_networking
    subnet_id           = can(each.value.subnet_id) || can(each.value.vnet_key) == false ? try(each.value.subnet_id, null) : try(local.combined_objects_virtual_subnets[try(each.value.lz_key, local.client_config.landingzone_key)][each.value.subnet_key].id, local.combined_objects_networking[try(each.value.lz_key, local.client_config.landingzone_key)][each.value.vnet_key].subnets[each.value.subnet_key].id)
    private_endpoints   = try(each.value.private_endpoints, {})
    virtual_subnets     = local.combined_objects_virtual_subnets
    private_dns_zone_id = can(each.value.private_dns_zone.key) ? local.combined_objects_private_dns[try(each.value.private_dns_zone.lz_key, local.client_config.landingzone_key)][each.value.private_dns_zone.key].id : null
    keyvault_id         = coalesce(
      try(each.value.administrator_login_password, null),
      try(module.keyvaults[each.value.keyvault_key].id, null),
      try(local.combined_objects_keyvaults[each.value.keyvault.lz_key][each.value.keyvault.key].id, null),
      try(local.combined_objects_keyvaults[local.client_config.landingzone_key][each.value.keyvault.key].id, null)
    )
    diagnostics         = local.combined_diagnostics
  }
}