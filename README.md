# Azure MySQL Terraform

This Terraform configuration provisions an Azure resource group and a MySQL
Flexible Server with a database and a firewall rule allowing access from one
client IPv4 address.

## What it creates

- Resource group: `devcommunity-rg-tf` in `polandcentral`
- MySQL Flexible Server: `devcommunity-mysql-unique`
    - MySQL 8.0.21, `B_Standard_B1ms` SKU, 20 GB storage
    - Seven-day backup retention
- Database: `devcommunity_db` (`utf8mb4`)
- Firewall rule allowing the configured `client_ip`

Names, location, and server settings are currently defined directly in
`main.tf`. The MySQL server name must be globally unique in Azure.

## Prerequisites

- Terraform with the AzureRM provider version `~> 3.0`
- An Azure subscription and credentials configured for Terraform (for example,
  sign in with `az login`)
- Permission to create the listed Azure resources
- Your public IPv4 address and a MySQL administrator password

## Configure

Provide the two required input variables in a local `terraform.tfvars` file:

```hcl
mysql_admin_password = "replace-with-a-strong-password"
client_ip            = "203.0.113.10"
```

Replace the example address with your public IPv4 address. Keep the password
out of source control; use a secure secrets mechanism or pass it through a
protected environment/CI variable instead of committing it in a `.tfvars` file.
Terraform state can also contain sensitive values, so protect the state file
and its storage.

## Deploy

```sh
terraform init
terraform validate
terraform plan
terraform apply
```

Terraform uses the configured Azure credentials and subscription. After
applying, retrieve the server hostname and database name with:

```sh
terraform output
```

The outputs are `mysql_server_fqdn` and `mysql_database_name`.

## Remove resources

To delete the resources managed by this configuration:

```sh
terraform destroy
```
