global_settings = {
  default_region = "region1"
  regions = {
    region1 = "southeastasia"
  }
}

resource_groups = {
  autoscale = {
    name = "autoscale"
    region = "region1"
  }
}

monitor_autoscale_settings = {
  profile1 = {
    name = "profile1"
    resource_group_key = "autoscale"

    vmss_key = "vmss1"

    capacity = {
      default = 1
      minimum = 1
      maximum = 3
    }

    rules = {
      rule1 = {
        metric_trigger = {
          metric_name        = "Percentage CPU"
          metric_resource_id = "id"
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
      }
    }

    recurrence = {
      timezone  = "Pacific Standard Time"
      days      = ["Saturday", "Sunday"]
      hours     = [12]
      minutes   = [0]
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
