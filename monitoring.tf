resource "azurerm_log_analytics_workspace" "main" {
  name                = "law-${local.prefix}-01"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  sku               = "PerGB2018"
  retention_in_days = 30

  daily_quota_gb = 0.1

  tags = local.tags
}


resource "azurerm_virtual_machine_extension" "azure_monitor" {
  name                       = "AzureMonitorLinuxAgent"
  virtual_machine_id         = azurerm_linux_virtual_machine.vm.id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true

  tags = local.tags
}


resource "azurerm_monitor_data_collection_rule" "linux" {
  name                = "dcr-${local.prefix}-linux-01"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  kind = "Linux"

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.main.id
      name                  = "northstar-logs"
    }
  }

  data_flow {
    streams      = ["Microsoft-Syslog"]
    destinations = ["northstar-logs"]
  }

  data_sources {
    syslog {
      name           = "linux-syslog"
      streams        = ["Microsoft-Syslog"]
      facility_names = ["auth", "authpriv", "daemon", "syslog"]
      log_levels     = ["Warning", "Error", "Critical", "Alert", "Emergency"]
    }
  }

  tags = local.tags
}


resource "azurerm_monitor_data_collection_rule_association" "linux_vm" {
  name                    = "dcra-${local.prefix}-vm-01"
  target_resource_id      = azurerm_linux_virtual_machine.vm.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.linux.id
}


resource "azurerm_monitor_metric_alert" "high_cpu" {
  name                = "alert-${local.prefix}-high-cpu"
  resource_group_name = azurerm_resource_group.main.name
  scopes              = [azurerm_linux_virtual_machine.vm.id]

  description = "Alert when VM CPU usage exceeds 80%."
  severity    = 2
  enabled     = true

  frequency   = "PT5M"
  window_size = "PT5M"

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.cpu_alerts.id
  }

  tags = local.tags
}
