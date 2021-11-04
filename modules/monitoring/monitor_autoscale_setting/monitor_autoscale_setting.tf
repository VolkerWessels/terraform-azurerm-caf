# resource "azurecaf_name" "this_name" {
#   name          = var.settings.action_group_name
#   prefixes      = var.global_settings.prefixes
#   resource_type = "azurerm_monitor_autoscale_setting"
#   random_length = var.global_settings.random_length
#   clean_input   = true
#   passthrough   = var.global_settings.passthrough
#   use_slug      = var.global_settings.use_slug
# }

resource "azurerm_monitor_autoscale_setting" "monitor_autoscale_setting_name" {
  name                = "test"
  # name                = azurecaf_name.this_name.result
  resource_group_name = var.resource_group_name
  location            = var.location
  target_resource_id  = var.virtual_machine_scale_set.name

  dynamic "profile_name" {
    for_each = try(var.monitor_autoscale_setting, {})
    content {
      profile {
        name = profile.value.name
      }
    }

    dynamic "capacity" {
      for_each = try(var.monitor_autoscale_setting.profile, {})
      content {
        capacity {
          default = capacity.value.default
          minimum = capacity.value.minimum
          maximum = capacity.value.maximum
        }
      }
    }

    rule {
      dynamic "metric_trigger" {
        for_each = try(var.monitor_autoscale_setting.rule, {})
        content {
          metric_trigger {
            metric_name        = metric_trigger.value.metric_name
            metric_resource_id = metric_trigger.value.metric_resource_id
            time_grain         = metric_trigger.value.time_grain
            statistic          = metric_trigger.value.statistic
            time_window        = metric_trigger.value.time_window
            time_aggregation   = metric_trigger.value.time_aggregation
            operator           = metric_trigger.value.operator
            threshold          = metric_trigger.value.threshold
          }
        }
      }
      dynamic "scale_action" {
        for_each = try(var.monitor_autoscale_setting.rule, {})
        content {
          scale_action {
            direction = scale_action.value.direction
            type      = scale_action.value.type
            value     = scale_action.value.value
            cooldown  = scale_action.value.cooldown
          }
        }
      }
      dynamic "recurrence" {
        for_each = try(var.monitor_autoscale_setting.rule, {})
        content {
          recurrence {
            frequency = recurrence.value.frequency
            timezone  = recurrence.value.timezone
            days      = recurrence.value.days
            hours     = recurrence.value.hours
            minutes   = recurrence.value.minutes
          }
        }
      }
    }

    notification {
      dynamic "email" {
        for_each = try(var.monitor_autoscale_setting.notification, {})
        content {
          email {
            send_to_subscription_administrator    = email.value.send_to_subscription_administrator
            send_to_subscription_co_administrator = email.value.send_to_subscription_co_administrator
            custom_emails                         = email.value.custom_emails
          }
        }
      }
    }
  }
}
