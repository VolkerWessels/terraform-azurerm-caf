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
    for_each = try(var.settings.profile, {})
    content {
      name = profile.value.name

      capacity {
        default = profile.capacity.value.default
        minimum = profile.capacity.value.minimum
        maximum = profile.capacity.value.maximum
      }
      rule {
        metric_trigger {
          metric_name        = profile.rule.metric_trigger.value.metric_name
          metric_resource_id = profile.rule.metric_trigger.value.metric_resource_id
          time_grain         = profile.rule.metric_trigger.value.time_grain
          statistic          = profile.rule.metric_trigger.value.statistic
          time_window        = profile.rule.metric_trigger.value.time_window
          time_aggregation   = profile.rule.metric_trigger.value.time_aggregation
          operator           = profile.rule.metric_trigger.value.operator
          threshold          = profile.rule.metric_trigger.value.threshold
        }
        scale_action {
          direction = profile.rule.scale_action.value.direction
          type      = profile.rule.scale_action.value.type
          value     = profile.rule.scale_action.value.value
          cooldown  = profile.rule.scale_action.value.cooldown
        }
      }
      recurrence {
        frequency = profile.rule.recurrence.value.frequency
        timezone  = profile.rule.recurrence.value.timezone
        days      = profile.rule.recurrence.value.days
        hours     = profile.rule.recurrence.value.hours
        minutes   = profile.rule.recurrence.value.minutes
      }
    }
    notification {
      email {
        send_to_subscription_administrator    = profile.notification.email.value.send_to_subscription_administrator
        send_to_subscription_co_administrator = profile.notification.email.value.send_to_subscription_co_administrator
        custom_emails                         = profile.notification.email.value.custom_emails
      }
    }
  }
}
