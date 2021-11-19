# resource "azurecaf_name" "this_name" {
#   name          = var.settings.name
#   prefixes      = var.global_settings.prefixes
#   resource_type = "azurerm_monitor_autoscale_setting"
#   random_length = var.global_settings.random_length
#   clean_input   = true
#   passthrough   = var.global_settings.passthrough
#   use_slug      = var.global_settings.use_slug
# }

resource "azurerm_monitor_autoscale_setting" "this" {
  # name                = azurecaf_name.this_name.result
  name                = "test"
  resource_group_name = var.resource_group_name
  location            = var.location
  target_resource_id  = var.target_resource_id

  dynamic "profile" {
    for_each = var.settings
    content {
      name = settings.name

      capacity {
        default = settings.capacity.default
        minimum = settings.capacity.minimum
        maximum = settings.capacity.maximum
      }

      dynamic "rule" {
        for_each = var.settings.rules
        content {
          metric_trigger {
            metric_name        = rule.value.metric_trigger.metric_name
            metric_resource_id = try(rule.value.metric_trigger.metric_resource_id, var.target_resource_id)
            time_grain         = rule.value.metric_trigger.time_grain
            statistic          = rule.value.metric_trigger.statistic
            time_window        = rule.value.metric_trigger.time_window
            time_aggregation   = rule.value.metric_trigger.time_aggregation
            operator           = rule.value.metric_trigger.operator
            threshold          = rule.value.metric_trigger.threshold
          }
          scale_action {
            direction = rule.value.scale_action.direction
            type      = rule.value.scale_action.type
            value     = rule.value.scale_action.value
            cooldown  = rule.value.scale_action.cooldown
          }
        }
      }

      dynamic "recurrence" {
        for_each = try(var.settings.recurrence, {})
        content {
          timezone = recurrence.timezone
          days     = recurrence.days
          hours    = recurrence.hours
          minutes  = recurrence.minutes
        }
      }

      dynamic "fixed_date" {
        for_each = try(var.settings.fixed_date, {})
        content {
          timezone = try(fixed_date.timezone, "")
          start    = fixed_date.start
          end      = fixed_date.end
        }
      }

    }

    notification {
      email {
        send_to_subscription_administrator    = settings.notification.email.send_to_subscription_administrator
        send_to_subscription_co_administrator = settings.notification.email.send_to_subscription_co_administrator
        custom_emails                         = settings.notification.email.custom_emails
      }
    }

  }
}
