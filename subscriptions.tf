
module "subscriptions" {
  source = "./modules/subscriptions"

  for_each = var.subscriptions

  global_settings  = local.global_settings
  subscription_key = each.key
  settings         = each.value
  client_config    = local.client_config
  diagnostics      = local.combined_diagnostics
  base_tags        = try(local.global_settings.inherit_tags, false) ? try(local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group.key, each.value.resource_group_key)].tags, {}) : {}
  tags             = merge(lookup(each.value, "tags", {}), var.tags)
}

module "subscription_billing_role_assignments" {
  source   = "./modules/subscription_billing_role_assignment"
  for_each = var.subscription_billing_role_assignments

  billing_role_definition_name = each.value.billing_role_definition_name
  client_config                = local.client_config
  cloud                        = local.cloud
  keyvaults                    = local.combined_objects_keyvaults
  settings                     = each.value
  principals = {
    azuread_users              = local.combined_objects_azuread_users
    managed_identities         = local.combined_objects_managed_identities
    azuread_service_principals = local.combined_objects_azuread_service_principals
  }
}

output "subscriptions" {
  value = module.subscriptions
}
