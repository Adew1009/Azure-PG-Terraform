terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_postgresql_flexible_server" "example" {
  name                   = var.server_name
  resource_group_name    = azurerm_resource_group.example.name
  location               = azurerm_resource_group.example.location
  administrator_login    = var.admin_username
  administrator_password = var.admin_password

  version    = var.postgres_version
  sku_name   = var.sku_name
  storage_mb = var.storage_mb

  zone = var.zone

  tags = var.tags
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
