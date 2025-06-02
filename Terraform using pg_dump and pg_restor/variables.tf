variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
  default     = "pg-terraform-rg"
}

variable "location" {
  type        = string
  description = "Azure region for resources"
  default     = "Central US"
}

variable "server_name" {
  type        = string
  description = "Name of the PostgreSQL Flexible Server (must be globally unique)"
}

variable "admin_username" {
  type        = string
  description = "Administrator username for PostgreSQL server"
  default     = "pgadmin"
}

variable "admin_password" {
  type        = string
  description = "Administrator password for PostgreSQL server"
  sensitive   = true
}

variable "postgres_version" {
  type        = string
  description = "PostgreSQL version"
  default     = "15"
}

variable "sku_name" {
  type        = string
  description = "SKU name for the PostgreSQL Flexible Server"
  default     = "GP_Standard_D2s_v3"
}

variable "storage_mb" {
  type        = number
  description = "Storage size in MB"
  default     = 32768
}

variable "zone" {
  type        = string
  description = "Availability zone"
  default     = "1"
}

variable "tags" {
  type        = map(string)
  description = "Tags for the resources"
  default = {
    environment = "dev"
  }
}

variable "my_ip" {
  type        = string
  description = "Your public IP address to allow through the firewall"
} 
