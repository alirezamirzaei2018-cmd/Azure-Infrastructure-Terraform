resource "azurerm_public_ip" "vm" {
  name                = "pip-${local.prefix}-vm-01"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  allocation_method = "Static"
  sku               = "Standard"

  tags = local.tags
}
