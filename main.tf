terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "devcommunity-rg-tf"
  location = "belgiumcentral"

  tags = {
    environment = "dev&test"
    value       = "devcommunity-db"
  }
}

# MySQL Flexible Server
resource "azurerm_mysql_flexible_server" "mysql" {
  name                = "devcommunity-mysql-db"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  administrator_login    = "youssef419386"
  administrator_password = var.mysql_admin_password

  backup_retention_days = 7
  sku_name              = "B_Standard_B1ms"
  version               = "8.0.21"

  storage {
    size_gb = 32
  }
}

# MySQL Database
resource "azurerm_mysql_flexible_database" "database" {
  name                = "devcommunity_db"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_flexible_server.mysql.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_unicode_ci"
}

# Firewall Rule - Your Public IP
resource "azurerm_mysql_flexible_server_firewall_rule" "my_ip" {
  name                = "allow-my-ip"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_flexible_server.mysql.name

  start_ip_address = var.client_ip
  end_ip_address   = var.client_ip
}

# Outputs
output "mysql_server_fqdn" {
  value = azurerm_mysql_flexible_server.mysql.fqdn
}

output "mysql_database_name" {
  value = azurerm_mysql_flexible_database.database.name
}
