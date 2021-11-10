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

  dynamic "profile" {
    for_each = var.settings.profile
    content {
      name = profile.value.name

      capacity {
        default = capacity.value.default
        minimum = capacity.value.minimum
        maximum = capacity.value.maximum
      }
      rule {
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
      recurrence {
        frequency = recurrence.value.frequency
        timezone  = recurrence.value.timezone
        days      = [recurrence.value.days]
        hours     = [recurrence.value.hours]
        minutes   = [recurrence.value.minutes]
      }
    }
    notification {
      email {
        send_to_subscription_administrator    = notification.email.value.send_to_subscription_administrator
        send_to_subscription_co_administrator = notification.email.value.send_to_subscription_co_administrator
        custom_emails                         = [notification.email.value.custom_emails]
      }
    }
  }
}
