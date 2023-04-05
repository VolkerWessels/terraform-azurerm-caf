output "postgresql_flexible_servers" {
  value = module.postgresql_flexible_servers
}

module "postgresql_flexible_servers" {
  source     = "./modules/databases/postgresql_flexible_server"
  depends_on = [module.keyvaults, module.networking]
  for_each   = local.database.postgresql_flexible_servers

  global_settings = local.global_settings
  client_config   = local.client_config
  settings        = each.value

  location       = can(local.global_settings.regions[each.value.region]) ? local.global_settings.regions[each.value.region] : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group.key, each.value.resource_group_key)].location
  resource_group = local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group.key, each.value.resource_group_key)]
  base_tags      = local.global_settings.inherit_tags

  remote_objects = {
    private_dns_zone_id = can(each.value.private_dns_zone.key) ? local.combined_objects_private_dns[try(each.value.private_dns_zone.lz_key, local.client_config.landingzone_key)][each.value.private_dns_zone.key].id : null
    diagnostics         = local.combined_diagnostics
    vnets               = local.combined_objects_networking
    virtual_subnets     = local.combined_objects_virtual_subnets
    private_dns         = local.combined_objects_private_dns
    private_endpoints   = try(each.value.private_endpoints, {})
  }
  subnet_id   = can(each.value.subnet_id) || can(each.value.vnet_key) == false ? try(each.value.subnet_id, null) : local.combined_objects_networking[try(each.value.lz_key, local.client_config.landingzone_key)][each.value.vnet_key].subnets[each.value.subnet_key].id
  keyvault_id = can(each.value.keyvault.key) ? local.combined_objects_keyvaults[try(each.value.keyvault.lz_key, local.client_config.landingzone_key)][each.value.keyvault.key].id : null

}
