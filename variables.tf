variable "admin_password" {
  type        = string
  description = "The administrator password for PostgreSQL server"
}
variable "my_ip" {
  type        = string
  description = "Your public IP address to allow through the firewall"
}
