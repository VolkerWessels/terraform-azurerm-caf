
module "automations" {
  source   = "./modules/automation"
  for_each = local.shared_services.automations

  global_settings     = local.global_settings
  settings            = each.value
  diagnostics         = local.combined_diagnostics
  location            = can(local.global_settings.regions[each.value.region]) ? local.global_settings.regions[each.value.region] : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group.key, each.value.resource_group_key)].location
  resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group_key, each.value.resource_group.key)].name
  base_tags           = try(local.global_settings.inherit_tags, false) ? try(local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group.key, each.value.resource_group_key)].tags, {}) : {}
}

output "automations" {
  value = module.automations

}

module "automation_log_analytics_links" {
  source   = "./modules/automation_log_analytics_links"
  depends_on = [module.automations, module.log_analytics]
  for_each = local.shared_services.automation_log_analytics_links

  global_settings     = local.global_settings
  settings            = each.value
  resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group_key, each.value.resource_group.key)].name
  workspace_id =    try(each.value.log_analytics_workspace_id, try(var.diagnostics.log_analytics[each.value.log_analytics_key].id, null))
  read_access_id = try(each.value.automation_account_id, try(module.automations[each.value.automation_account_key].id, null))
}

output "automation_log_analytics_links" {
  value = module.automation_log_analytics_links
}


resource "null_resource" "debug" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "echo $VARIABLE1 >> autodebug.json;echo $VARIABLE2 >> autodebug.json; cat autodebug.json"
    environment = {
      VARIABLE1 = jsonencode(try(var.diagnostics.log_analytics, ""))
      VARIABLE2 = jsonencode(try(var.automations, ""))
    }
  }
}
