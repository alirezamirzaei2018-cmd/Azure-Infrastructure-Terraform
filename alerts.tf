resource "azurerm_monitor_action_group" "cpu_alerts" {
  name                = "ag-northstar-dev-cc-alerts"
  resource_group_name = azurerm_resource_group.main.name
  short_name          = "NorthstarCPU"

  email_receiver {
    name          = "Email-CPU-Alert"
    email_address = var.alert_email
  }

  tags = {
    Environment = "dev"
    ManagedBy   = "Terraform"
    Project     = "Portfolio-Project-02"
  }
}