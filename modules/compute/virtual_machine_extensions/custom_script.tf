resource "azurerm_virtual_machine_extension" "custom_script" {
  for_each                   = var.extension_name == "custom_script" ? toset(["enabled"]) : toset([])
  name                       = "custom_script"
  virtual_machine_id         = var.virtual_machine_id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.10"
  auto_upgrade_minor_version = true

  settings = jsonencode(
    {
      "fileUris" : try(var.extension.fileuris, ""),
      "timestamp" : try(var.extension.timestamp, formatdate("YYYYMMDDhhmmss", timestamp()))
    }
  )
  protected_settings = jsonencode(
    {
      "commandToExecute" : try(var.extension.commandtoexecute, ""),
      "managedIdentity" : { "objectid" : "${local.managed_identity}" }   
    }
  )
}

#
# Managed identities from remote state
#

locals {
  managed_local_identity = try(var.managed_identities[var.client_config.landingzone_key][var.extension.managed_identity_key].princpal_id, "")
  managed_remote_identity = try(var.managed_identities[var.extension.lz_key][var.extension.managed_identity_key].principal_id, "")

  # managed_remote_identities = flatten([
  #   for keyvault_key, value in try(var.settings.virtual_machine_settings[local.os_type].identity.remote, []) : [
  #     for managed_identity_key in value.managed_identity_keys : [
  #       var.managed_identities[keyvault_key][managed_identity_key].id
  #     ]
  #   ]
  # ])

  # provided_identities = try(var.settings.virtual_machine_settings[local.os_type].identity.managed_identity_ids, [])

  #managed_identities = concat(local.provided_identities, local.managed_local_identities, local.managed_remote_identities)
  managed_identity = coalesce(local.managed_local_identity, local.managed_remote_identity)
}

variable "managed_identities" {
  default = {}
}

output "cse_managed_identity" {
  value = local.managed_identity
}
