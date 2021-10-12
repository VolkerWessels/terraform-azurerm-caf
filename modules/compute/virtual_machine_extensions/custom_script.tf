resource "azurerm_virtual_machine_extension" "custom_scriptextension" {
  for_each                   = var.extension_name == "custom_script" ? toset(["enabled"]) : toset([])
  name                       = "custom_script"
  virtual_machine_id         = var.virtual_machine_id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.10"
  auto_upgrade_minor_version = true

  settings = jsonencode(
    {
      "fileUris" : try(var.extension.file_uris, ""),
      "timestamp" : try(var.extension.timestamp, "12345678")
    }
  )
  protected_settings = jsonencode(
    {
      "commandToExecute" : try(var.extension.commandtoexecute, "")
    }
  )
}