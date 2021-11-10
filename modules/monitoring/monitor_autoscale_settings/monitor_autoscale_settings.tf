#resource "azurecaf_name" "this_name" {
#   name          = var.settings.action_group_name
#   prefixes      = var.global_settings.prefixes
#   resource_type = "azurerm_monitor_autoscale_setting"
#   random_length = var.global_settings.random_length
#   clean_input   = true
#   passthrough   = var.global_settings.passthrough
#   use_slug      = var.global_settings.use_slug
# }

resource "azurerm_monitor_autoscale_setting" "this" {
  name                = "test"
  # name                = azurecaf_name.this_name.result
  resource_group_name = var.resource_group_name
  location            = var.location
  target_resource_id  = var.target_resource_id

  profile {
    name = var.settings.name

    capacity {
      default = var.settings.capacity.value.default
      minimum = var.settings.capacity.value.minimum
      maximum = var.settings.capacity.value.maximum
    }

    dynamic "rule" {
      for_each = var.settings.rule
      content {
        metric_trigger {
          metric_name        = rule.metric_trigger.value.metric_name
          metric_resource_id = rule.metric_trigger.value.metric_resource_id
          time_grain         = rule.metric_trigger.value.time_grain
          statistic          = rule.metric_trigger.value.statistic
          time_window        = rule.metric_trigger.value.time_window
          time_aggregation   = rule.metric_trigger.value.time_aggregation
          operator           = rule.metric_trigger.value.operator
          threshold          = rule.metric_trigger.value.threshold
        }
        scale_action {
          direction = rule.scale_action.value.direction
          type      = rule.scale_action.value.type
          value     = rule.scale_action.value.value
          cooldown  = rule.scale_action.value.cooldown
        }
      }
    }
    recurrence {
      timezone  = var.settings.recurrence.value.timezone
      days      = var.settings.recurrence.value.days
      hours     = var.settings.recurrence.value.hours
      minutes   = var.settings.recurrence.value.minutes
    }
  }
  notification {
    email {
      send_to_subscription_administrator    = var.settings.notification.email.value.send_to_subscription_administrator
      send_to_subscription_co_administrator = var.settings.notification.email.value.send_to_subscription_co_administrator
      custom_emails                         = var.settings.notification.email.value.custom_emails
    }
  }
}
