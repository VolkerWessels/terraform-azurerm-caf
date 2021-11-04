# module "monitor_autoscale_setting" {
#   source              = "./modules/monitor_autoscale_setting"
#   for_each            = local.shared_services.monitor_autoscale_setting
#   global_settings     = local.global_settings
#   settings            = each.value
#   resource_group_name = local.resource_groups[each.value.resource_group_key].name
#   location            = lookup(each.value, "region", null) == null ? local.resource_groups[each.value.resource_group_key].location : local.global_settings.regions[each.value.region]
# }
