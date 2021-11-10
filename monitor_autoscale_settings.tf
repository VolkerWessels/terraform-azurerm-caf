module "monitor_autoscale_settings" {
  depends_on          = [module.virtual_machine_scale_sets]
  source              = "./modules/monitoring/monitor_autoscale_settings"
  for_each            = local.shared_services.monitor_autoscale_settings
  settings            = each.value
  global_settings     = local.global_settings
  resource_group_name = local.combined_objects_resource_groups[try(each.value.lz_key, local.client_config.landingzone_key)][each.value.resource_group_key].name
  location            = lookup(each.value, "region", null) == null ? local.resource_groups[each.value.resource_group_key].location : local.global_settings.regions[each.value.region]
  target_resource_id  = module.virtual_machine_scale_sets.id[local.compute.virtual_machine_scale_sets.keys]
}
