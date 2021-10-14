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
      "managedIdentity" : { "objectid" : try(local.managed_identities, "") }      
    }
  )
}

#
# Managed identities from remote state
#

locals {
  managed_local_identities = flatten([
    for managed_identity_key in try(var.extension.managed_identity_keys, []) : [
      var.managed_identities[var.client_config.landingzone_key][managed_identity_key].principal_id
    ]
  ])

  managed_remote_identities = flatten([
    for lz_key, value in try(var.extension.identity.remote, []) : [
      for managed_identity_key in value.managed_identity_keys : [
        var.managed_identities[lz_key][managed_identity_key].principal_id
      ]
    ]
  ])

  managed_identities = coalesce(local.managed_local_identities, local.managed_remote_identities)
}

variable "managed_identities" {
  default = {}
}

output "protectedsettings" {
  value = local.managed_identities
}