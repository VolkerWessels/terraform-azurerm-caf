resource "azurerm_log_analytics_linked_service" "linked_service" {
  resource_group_name = var.resource_group_name
  workspace_id = var.settings.workspace_id
  read_access_id = var.settings.read_access_id
}
