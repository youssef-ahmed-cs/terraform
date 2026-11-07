variable "mysql_admin_password" {
  description = "MySQL administrator password"
  type        = string
  sensitive   = true
}

variable "client_ip" {
  description = "Your public IPv4 address"
  type        = string
}