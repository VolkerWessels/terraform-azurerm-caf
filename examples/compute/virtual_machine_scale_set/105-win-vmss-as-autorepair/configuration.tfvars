global_settings = {
  default_region = "region1"
  regions = {
    region1 = "southeastasia"
  }
}

resource_groups = {
  rg1 = {
    name = "vmss-lb-exmp-rg"
  }
}

managed_identities = {
  example_mi = {
    name               = "example_mi"
    resource_group_key = "rg1"
  }
}

vnets = {
  vnet1 = {
    resource_group_key = "rg1"
    vnet = {
      name          = "vmss"
      address_space = ["10.100.0.0/16"]
    }
    specialsubnets = {}
    subnets = {
      subnet1 = {
        name = "compute"
        cidr = ["10.100.1.0/24"]
      }
    }
  }
}


keyvaults = {
  kv1 = {
    name               = "vmsslbexmpkv1"
    resource_group_key = "rg1"
    sku_name           = "standard"
    purge_protection_enabled = "false"
    creation_policies = {
      logged_in_user = {
        secret_permissions = ["Set", "Get", "List", "Delete", "Purge", "Recover"]
      }
    }
  }
}


diagnostic_storage_accounts = {
  # Stores boot diagnostic for region1
  bootdiag1 = {
    name                     = "lebootdiag1"
    resource_group_key       = "rg1"
    account_kind             = "StorageV2"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    access_tier              = "Cool"
  }
}

# Application security groups
application_security_groups = {
  app_sg1 = {
    resource_group_key = "rg1"
    name               = "app_sg1"

  }
}

# Load Balancer
public_ip_addresses = {
  lb_pip1 = {
    name               = "lb_pip1"
    resource_group_key = "rg1"
    sku                = "Basic"
    # Note: For UltraPerformance ExpressRoute Virtual Network gateway, the associated Public IP needs to be sku "Basic" not "Standard"
    allocation_method = "Dynamic"
    # allocation method needs to be Dynamic
    ip_version              = "IPv4"
    idle_timeout_in_minutes = "4"
  }
}

# Public Load Balancer will be created. For Internal/Private Load Balancer config, please refer 102-internal-load-balancer example.

load_balancers = {
  lb1 = {
    name                      = "lb-vmss"
    sku                       = "basic"
    resource_group_key        = "rg1"
    backend_address_pool_name = "vmss1"
    frontend_ip_configurations = {
      config1 = {
        name                  = "config1"
        public_ip_address_key = "lb_pip1"
      }
    }
      probes = {
      probe1 = {
        resource_group_key  = "rg1"
        load_balancer_key   = "lb-vmss"
        probe_name          = "probe1"
        port                = "80"
        interval_in_seconds = "20"
        number_of_probes    = "3"
      }
  }
  lb_rules = {
      rule1 = {
        resource_group_key  = "bc_app_vmss"
        load_balancer_key   = "lb-vmss"
        lb_rule_name                   = "rule1"
        protocol                       = "tcp"
        probe_id_key                   = "probe1"
        frontend_port                  = "80"
        backend_port                   = "80"
        enable_floating_ip             = "false"
        idle_timeout_in_minutes        = "4"
        load_distribution              = "SourceIPProtocol"
        disable_outbound_snat          = "false"
        enable_tcp_rest                = "false"
        frontend_ip_configuration_name = "config1" #name must match the configuration that's defined in the load_balancers block.
      }
    }
  }
}


virtual_machine_scale_sets = {
  vmss1 = {
    resource_group_key                   = "rg1"
    provision_vm_agent                   = true
    boot_diagnostics_storage_account_key = "bootdiag1"
    os_type                              = "windows"
    keyvault_key                         = "kv1"

    vmss_settings = {
      windows = {
        name                            = "win"
        computer_name_prefix            = "win"
        sku                             = "Standard_F2"
        instances                       = 1
        admin_username                  = "adminuser"
        disable_password_authentication = true
        #priority                        = "Spot"
        #eviction_policy                 = "Deallocate"

        upgrade_mode = "Manual" # Automatic / Rolling / Manual

        # rolling_upgrade_policy = {
        #   # Only for upgrade mode = "Automatic / Rolling "
        #   max_batch_instance_percent = 20
        #   max_unhealthy_instance_percent = 20
        #   max_unhealthy_upgraded_instance_percent = 20
        #   pause_time_between_batches = ""
        # }
        # automatic_os_upgrade_policy = {
        #   # Only for upgrade mode = "Automatic"
        #   disable_automatic_rollback = false
        #   enable_automatic_os_upgrade = true
        # }

        os_disk = {
          caching              = "ReadWrite"
          storage_account_type = "Standard_LRS"
          disk_size_gb         = 128
        }
        health_probe_id = "/subscriptions/507ac163-3bf1-4184-afca-b269731ede18/resourceGroups/zahd-rg-vmss-lb-exmp-rg/providers/Microsoft.Network/loadBalancers/zahd-lb-lb-vmss/probes/probe1"
        automatic_instance_repair = {
          enabled = true
          grace_period = "PT30M"
        }

        identity = {
          type                  = "SystemAssigned"
          managed_identity_keys = []
        }

        source_image_reference = {
          publisher = "MicrosoftWindowsServer"
          offer     = "WindowsServer"
          sku       = "2016-Datacenter"
          version   = "latest"
        }

      }
    }

    virtual_machine_scale_set_extensions = {
      custom_script = {
        fileuris            = ["https://someonewhocares.org/hosts/hosts"]
        # can define fileuris directly or use fileuri_sa_ reference keys and lz_key:
        #fileuri_sa_key   = "sa1"
        #fileuri_sa_path  = "files/helloworld.ps1"
        commandtoexecute = "PowerShell -command {Install-WindowsFeature -name Web-Server -IncludeManagementTools}"
        # managed_identity_id = optional to define managed identity principal_id directly
        #identity_type        = "UserAssigned" #optional to use managed_identity for download from location specified in fileuri, UserAssigned or SystemAssigned.
        #managed_identity_key = "example_mi"
        #lz_key               = "other_lz" optional for managed identity defined in other lz
      }
    }
    network_interfaces = {
      nic0 = {
        # Value of the keys from networking.tfvars
        name       = "0"
        primary    = true
        vnet_key   = "vnet1"
        subnet_key = "subnet1"

        load_balancers = {
          lb1 = {
            lb_key = "lb1"
            # lz_key = ""
          }
        }

        application_security_groups = {
          asg1 = {
            asg_key = "app_sg1"
            # lz_key = ""
          }
        }

        enable_accelerated_networking = false
        enable_ip_forwarding          = false
        internal_dns_name_label       = "nic0"
      }
    }
    ultra_ssd_enabled = false # required if planning to use UltraSSD_LRS

    data_disks = {
      data1 = {
        caching                   = "None"  # None / ReadOnly / ReadWrite
        create_option             = "Empty" # Empty / FromImage (only if source image includes data disks)
        disk_size_gb              = "10"
        lun                       = 1
        storage_account_type      = "Standard_LRS" # UltraSSD_LRS only possible when > additional_capabilities { ultra_ssd_enabled = true }
        disk_iops_read_write      = 100            # only for UltraSSD Disks
        disk_mbps_read_write      = 100            # only for UltraSSD Disks
        write_accelerator_enabled = false          # true requires Premium_LRS and caching = "None"
        # disk_encryption_set_key = "set1"
        # lz_key = "" # lz_key for disk_encryption_set_key if remote
      }
    }

  }

}
monitor_autoscale_settings = {
  profile1 = {
    name               = "profile1"
    resource_group_key = "rg1"

    vmss_key = "vmss1"

    capacity = {
      default = 1
      minimum = 1
      maximum = 3
    }

    rules = {
      rule1 = {
        metric_trigger = {
          metric_name = "Percentage CPU"
          # You can also choose your resource id manually, in case it is required
          # metric_resource_id = "/subscriptions/manual-id"
          time_grain       = "PT1M"
          statistic        = "Average"
          time_window      = "PT5M"
          time_aggregation = "Average"
          operator         = "GreaterThan"
          threshold        = 90
        }
        scale_action = {
          direction = "Increase"
          type      = "ChangeCount"
          value     = "2"
          cooldown  = "PT1M"
        }
      }
    }

    # Note: use either recurrence or fixed_date
    # recurrence = {
    #   timezone = "Pacific Standard Time"
    #   days     = ["Saturday", "Sunday"]
    #   hours    = [12]
    #   minutes  = [0]
    # }

    # Note: use either fixed_date or recurrence
    # fixed_date = {
    #   timezone = "Pacific Standard Time"
    #   start    = "2020-07-01T00:00:00Z"
    #   end      = "2020-07-31T23:59:59Z"
    # }

    notification = {
      email = {
        send_to_subscription_administrator    = true
        send_to_subscription_co_administrator = true
        custom_emails                         = ["admin@contoso.com"]
      }
    }
  }
}