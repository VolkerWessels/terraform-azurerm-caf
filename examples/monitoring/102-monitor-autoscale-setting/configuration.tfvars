resource_groups = {
  autoscale = {
    name = "autoscale"
  }
}

monitor_autoscale_setting = {
  profile = {
    name = profile1

    capacity = {
      default = 1
      minimum = 1
      maximum = 3
    }

    rule = {
      metric_trigger = {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_virtual_machine_scale_set.example.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 90
      }
      scale_action = {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "2"
        cooldown  = "PT1M"
      }
      recurrence = {
        frequency = "Week"
        timezone  = "Pacific Standard Time"
        days      = ["Saturday", "Sunday"]
        hours     = [12]
        minutes   = [0]
      }
    }

    notification = {
      email = {
        send_to_subscription_administrator    = true
        send_to_subscription_co_administrator = true
        custom_emails                         = ["admin@contoso.com"]
      }
    }
  }
}
