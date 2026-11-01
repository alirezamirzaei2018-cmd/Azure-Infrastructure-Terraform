resource "azurerm_recovery_services_vault" "northstar" {
  name                = "rsv-northstar-dev-cc-01"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "Standard"

  storage_mode_type = "LocallyRedundant"

  tags = {
    Environment = "dev"
    ManagedBy   = "Terraform"
    Project     = "Portfolio-Project-02"
  }
}

resource "azurerm_backup_policy_vm" "northstar" {
  name                = "policy-northstar-dev-daily"
  resource_group_name = azurerm_resource_group.main.name
  recovery_vault_name = azurerm_recovery_services_vault.northstar.name

  timezone = "Eastern Standard Time"

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 7
  }

}

resource "azurerm_backup_protected_vm" "northstar" {
  resource_group_name = azurerm_resource_group.main.name
  recovery_vault_name = azurerm_recovery_services_vault.northstar.name
  source_vm_id        = azurerm_linux_virtual_machine.vm.id
  backup_policy_id    = azurerm_backup_policy_vm.northstar.id
}