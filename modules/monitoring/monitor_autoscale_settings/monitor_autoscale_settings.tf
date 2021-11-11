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
      default = var.settings.capacity.default
      minimum = var.settings.capacity.minimum
      maximum = var.settings.capacity.maximum
    }

    dynamic "rule" {
      for_each = var.settings.rules
      content {
        metric_trigger {
          metric_name        = rules.rule.metric_trigger.value.metric_name
          metric_resource_id = rules.rule.metric_trigger.value.metric_resource_id
          time_grain         = rules.rule.metric_trigger.value.time_grain
          statistic          = rules.rule.metric_trigger.value.statistic
          time_window        = rules.rule.metric_trigger.value.time_window
          time_aggregation   = rules.rule.metric_trigger.value.time_aggregation
          operator           = rules.rule.metric_trigger.value.operator
          threshold          = rules.rule.metric_trigger.value.threshold
        }
        scale_action {
          direction = rules.rule.scale_action.value.direction
          type      = rules.rule.scale_action.value.type
          value     = rules.rule.scale_action.value.value
          cooldown  = rules.rule.scale_action.value.cooldown
        }
      }
    }

    recurrence {
      timezone  = var.settings.recurrence.timezone
      days      = var.settings.recurrence.days
      hours     = var.settings.recurrence.hours
      minutes   = var.settings.recurrence.minutes
    }
  }

  notification {
    email {
      send_to_subscription_administrator    = var.settings.notification.email.send_to_subscription_administrator
      send_to_subscription_co_administrator = var.settings.notification.email.send_to_subscription_co_administrator
      custom_emails                         = var.settings.notification.email.custom_emails
    }
  }
}
