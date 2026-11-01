
resource "azurerm_network_interface" "vm" {
  name                = "nic-${local.prefix}-01"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name


  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.workload.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm.id
  }


  tags = local.tags
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm-${local.prefix}-01"
  custom_data         = base64encode(file("${path.module}/cloud-init.yaml"))
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = var.vm_size

  admin_username                  = var.admin_username
  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.vm.id
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  identity {
    type = "SystemAssigned"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  tags = local.tags
}
