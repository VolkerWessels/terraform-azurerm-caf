resource "azurerm_security_center_auto_provisioning" "default" {
  auto_provision = var.settings.auto_provision
}

resource "azurerm_security_center_server_vulnerability_assessment_virtual_machine" "default" {
  virtual_machine_id = var.settings.virtual_machine_id
}
