

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "pg-terraform-rg"
  location = "centralus"
}

resource "azurerm_postgresql_flexible_server" "example" {
  name                   = "mypgflexserver5432"
  resource_group_name    = azurerm_resource_group.example.name
  location               = azurerm_resource_group.example.location
  version                = "15"
  administrator_login    = "pgadmin"
  administrator_password = var.admin_password
  sku_name               = "GP_Standard_D2s_v3"
  storage_mb             = 32768
  zone                   = "1"
  tags = {
    environment = "dev"
  }
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_my_ip" {
  name             = "AllowMyIP"
  server_id        = azurerm_postgresql_flexible_server.example.id
  start_ip_address = var.my_ip
  end_ip_address   = var.my_ip
}

output "postgresql_flexible_server_fqdn" {
  value = azurerm_postgresql_flexible_server.example.fqdn
}
