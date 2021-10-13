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
      "managedIdentity" : try(var.extension.managedidentity, "")
    }
  )
}