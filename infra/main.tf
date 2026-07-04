# ============================
# リソースグループ
# ============================
resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
}

# ============================
# 仮想ネットワーク
# ============================
resource "azurerm_virtual_network" "this" {
  name                = "vnet-sample"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.this.location
  resource_group_name  = azurerm_resource_group.this.name
}

resource "azurerm_subnet" "this" {
  name                 = "subnet-sample"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.1.0/24"]
}

# ============================
# ネットワークセキュリティグループ（SSHのみ許可）
# ============================
resource "azurerm_network_security_group" "this" {
  name                = "nsg-sample"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"   # 検証用。本番では自分のIPに絞ることを推奨
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "this" {
  subnet_id                 = azurerm_subnet.this.id
  network_security_group_id = azurerm_network_security_group.this.id
}

# ============================
# パブリックIP
# ============================
resource "azurerm_public_ip" "this" {
  name                = "pip-sample"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# ============================
# ネットワークインターフェース
# ============================
resource "azurerm_network_interface" "this" {
  name                = "nic-sample"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.this.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.this.id
  }
}

# ============================
# Linux仮想マシン
# ============================
resource "azurerm_linux_virtual_machine" "this" {
  name                = var.vm_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  size                = var.vm_size
  admin_username      = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.this.id
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  disable_password_authentication = true
}