README: Azure PostgreSQL Flexible Server Setup and Database Migration
<!-- !START -->
<!-- todo 1. Terraform: Provision Azure PostgreSQL Flexible Server and Firewall Rule -->
Update main.tf with:

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
  name     = "pg-terraform-rg"
  location = "Central US"
}

resource "azurerm_postgresql_flexible_server" "example" {
  name                   = "your-server-name" # must be globally unique
  resource_group_name    = azurerm_resource_group.example.name
  location               = azurerm_resource_group.example.location
  administrator_login    = "your_admin_username"
  administrator_password = "your_secure_password" # Make this secure

  version    = "15"
  sku_name   = "GP_Standard_D2s_v3"
  storage_mb = 32768

  zone = "1"

  tags = {
    environment = "dev"
  }
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_my_ip" {
  name             = "AllowMyIP"
  server_id        = azurerm_postgresql_flexible_server.example.id
  start_ip_address = "your_ip_address"
  end_ip_address   = "your_ip_address"
}
<!--  -->

<!-- todo Run Terraform commands: -->

terraform init
terraform plan
terraform apply
# Enter "yes" to confirm


<!-- todo 2. Connect to Azure PostgreSQL with psql -->
bash
Copy
Edit
psql "host=your-server-name.postgres.database.azure.com port=5432 dbname=postgres user=your_admin_username password=YourStrongPasswordHere sslmode=require"
<!-- todo 3. Create a new database on Azure server (to match your local DB name) -->
CREATE DATABASE nps_db;
\q
<!-- todo -->

psql "host=your-server-name.postgres.database.azure.com port=5432 dbname=nps_db user=your_admin_username password=YourStrongPasswordHere sslmode=require"

CREATE ROLE "your_username" NOLOGIN;
\q
<!-- todo 5. Restore your local PostgreSQL dump to Azure (skip ownership) --> This uses pd_dump and pg_restore
pg_dump -U your_local_user -d your_local_dbname -Fc -f local_backup.dump

pg_restore --verbose --clean --no-owner \
  -h your-server-name.postgres.database.azure.com \
  -U your_admin_username \
  -d postgres \
  local_backup.dump

pg_restore --no-owner -h your-server-name.postgres.database.azure.com -U your_admin_username -d nps_db --clean path/to/your/dumpfile.dump

<!-- todo  -->

psql "host=your-server-name.postgres.database.azure.com port=5432 dbname=nps_db user=your_admin_username password=YourStrongPasswordHere sslmode=require"

\dt


<!-- ! DONE -->

<!-- SECURITY NOTE: This file has been sanitized for public repository use. 
     Before using this template:
     1. Replace all placeholder values (your-server-name, your_admin_username, your_secure_password, etc.)
     2. Use strong, unique passwords
     3. Consider using Azure Key Vault for sensitive values
     4. Never commit actual credentials or IP addresses to version control
-->






No file chosenNo file chosen
ChatGPT can make mistakes. Check important info.


psql "host=mypgflexserver5432.postgres.database.azure.com port=5432 dbname=postgres user=pgadmin password=PASSword01 sslmode=require" 

pg_dump -U your_local_user -d your_local_dbname -Fc -f local_backup.dump
pg_restore --verbose --clean --no-owner \
  -h mypgflexserver5432.postgres.database.azure.com \
  -U pgadmin \
  -d postgres \
  local_backup.dump


  (default) ➜  azure-pg-terraform pg_restore --no-owner -h mypgflexserver5432.postgres.database.azure.com -U pgadmin -d nps_db --clean nps_db.dump        
Password: 
(default) ➜  azure-pg-terraform psql "host=mypgflexserver5432.postgres.database.azure.com dbname=postgres user=pgadmin password=PASSword01 sslmode=require"           

psql (14.17 (Homebrew), server 15.12)
WARNING: psql major version 14, server major version 15.
         Some psql features might not work.
SSL connection (protocol: TLSv1.3, cipher: TLS_AES_256_GCM_SHA384, bits: 256, compression: off)
Type "help" for help.

postgres=> \l
                                              List of databases
       Name        |     Owner      | Encoding |  Collate   |   Ctype    |         Access privileges         
-------------------+----------------+----------+------------+------------+-----------------------------------
 azure_maintenance | azuresu        | UTF8     | en_US.utf8 | en_US.utf8 | 
 azure_sys         | azuresu        | UTF8     | en_US.utf8 | en_US.utf8 | 
 nps_db            | pgadmin        | UTF8     | en_US.utf8 | en_US.utf8 | 
 postgres          | azure_pg_admin | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0         | azure_pg_admin | UTF8     | en_US.utf8 | en_US.utf8 | =c/azure_pg_admin                +
                   |                |          |            |            | azure_pg_admin=CTc/azure_pg_admin
 template1         | azure_pg_admin | UTF8     | en_US.utf8 | en_US.utf8 | =c/azure_pg_admin                +
                   |                |          |            |            | azure_pg_admin=CTc/azure_pg_admin
(6 rows)

postgres=> \dt
                       List of relations
 Schema |                Name                | Type  |  Owner  
--------+------------------------------------+-------+---------
 public | allparks_app_activity              | table | pgadmin
 public | allparks_app_address               | table | pgadmin
 public | allparks_app_contact               | table | pgadmin
 public | allparks_app_entrancefee           | table | pgadmin
 public | allparks_app_image                 | table | pgadmin
 public | allparks_app_operatinghour         | table | pgadmin
 public | allparks_app_park                  | table | pgadmin
 public | allparks_app_park_addresses        | table | pgadmin
 public | allparks_app_park_entrance_fees    | table | pgadmin
 public | allparks_app_park_images           | table | pgadmin
 public | allparks_app_park_operating_hours  | table | pgadmin
 public | allparks_app_parkactivity          | table | pgadmin
 public | allparks_app_parktopic             | table | pgadmin
 public | allparks_app_topic                 | table | pgadmin
 public | api_app_address                    | table | pgadmin
 public | auth_group                         | table | pgadmin
 public | auth_group_permissions             | table | pgadmin
 public | auth_permission                    | table | pgadmin
 public | authtoken_token                    | table | pgadmin
 public | django_admin_log                   | table | pgadmin
 public | django_content_type                | table | pgadmin
 public | django_migrations                  | table | pgadmin
 public | django_session                     | table | pgadmin
 public | user_app_app_user                  | table | pgadmin
 public | user_app_app_user_groups           | table | pgadmin
 public | user_app_app_user_user_permissions | table | pgadmin
 public | visited_app_visited                | table | pgadmin
 public | wishlist_app_wishlist              | table | pgadmin
(28 rows)

postgres=> \c nps_db
psql (14.17 (Homebrew), server 15.12)
WARNING: psql major version 14, server major version 15.
         Some psql features might not work.
SSL connection (protocol: TLSv1.3, cipher: TLS_AES_256_GCM_SHA384, bits: 256, compression: off)
You are now connected to database "nps_db" as user "pgadmin".
nps_db=> \dt
                       List of relations
 Schema |                Name                | Type  |  Owner  
--------+------------------------------------+-------+---------
 public | allparks_app_activity              | table | pgadmin
 public | allparks_app_address               | table | pgadmin
 public | allparks_app_contact               | table | pgadmin
 public | allparks_app_entrancefee           | table | pgadmin
 public | allparks_app_image                 | table | pgadmin
 public | allparks_app_operatinghour         | table | pgadmin
 public | allparks_app_park                  | table | pgadmin
 public | allparks_app_park_addresses        | table | pgadmin
 public | allparks_app_park_entrance_fees    | table | pgadmin
 public | allparks_app_park_images           | table | pgadmin
 public | allparks_app_park_operating_hours  | table | pgadmin
 public | allparks_app_parkactivity          | table | pgadmin
 public | allparks_app_parktopic             | table | pgadmin
 public | allparks_app_topic                 | table | pgadmin
 public | api_app_address                    | table | pgadmin
 public | auth_group                         | table | pgadmin
 public | auth_group_permissions             | table | pgadmin
 public | auth_permission                    | table | pgadmin
 public | authtoken_token                    | table | pgadmin
 public | django_admin_log                   | table | pgadmin
 public | django_content_type                | table | pgadmin
 public | django_migrations                  | table | pgadmin
 public | django_session                     | table | pgadmin
 public | user_app_app_user                  | table | pgadmin
 public | user_app_app_user_groups           | table | pgadmin
 public | user_app_app_user_user_permissions | table | pgadmin
 public | visited_app_visited                | table | pgadmin
 public | wishlist_app_wishlist              | table | pgadmin
(28 rows)

nps_db=> 
