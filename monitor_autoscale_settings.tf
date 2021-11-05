module "monitor_autoscale_settings" {
  depends_on          = [module.virtual_machine_scale_sets]
  source              = "./modules/monitoring/monitor_autoscale_settings"
  for_each            = local.shared_services.monitor_autoscale_settings
  global_settings     = local.global_settings
  settings            = each.value
  resource_group_name = local.resource_groups[each.value.resource_group_key].name
  location            = lookup(each.value, "region", null) == null ? local.resource_groups[each.value.resource_group_key].location : local.global_settings.regions[each.value.region]
  target_resource_id  = module.virtual_machine_scale_sets.azurerm_virtual_machine_scale_set.vmss[try(each.value.virtual_machine_scale_sets.key)].id
  # target_resource_id  = azurerm_virtual_machine_scale_set.vmss[try(each.value.virtual_machine_scale_sets.key)].id
}
