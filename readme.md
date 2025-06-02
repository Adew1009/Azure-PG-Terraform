# Azure PostgreSQL Flexible Server with Terraform

This repository provides infrastructure as code (IaC) using Terraform to deploy an Azure PostgreSQL Flexible Server and includes scripts for database migration. It's designed to help you quickly set up a production-ready PostgreSQL database in Azure with proper security configurations.

## Project Structure

```
.
├── main.tf                 # Main Terraform configuration
├── variables.tf            # Variable definitions
├── terraform.tfvars.example # Example variable values (template)
├── migrate.sh             # Database migration script
└── .gitignore            # Git ignore rules for sensitive files
```

## Features

- **Infrastructure as Code**: Complete Azure PostgreSQL Flexible Server setup using Terraform
- **Security First**: 
  - Configurable firewall rules
  - Secure password management
  - SSL/TLS encryption enabled
- **Database Migration**: Scripts to migrate existing PostgreSQL databases
- **Environment Management**: Support for different environments (dev, staging, prod)

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) (v1.0.0+)
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- [PostgreSQL Client](https://www.postgresql.org/download/)
- Azure subscription with appropriate permissions

## Quick Start

1. **Clone and Initialize**:
   ```bash
   git clone <repository-url>
   cd azure-pg-terraform
   ```

2. **Configure Variables**:
   ```bash
   # Copy the example vars file
   cp terraform.tfvars.example terraform.tfvars
   
   # Edit terraform.tfvars with your values
   # Required values:
   # - server_name (must be globally unique)
   # - admin_password
   # - my_ip
   ```

3. **Deploy Infrastructure**:
   ```bash
   # Initialize Terraform
   terraform init

   # Review the deployment plan
   terraform plan

   # Deploy the infrastructure
   terraform apply
   ```

## Database Migration

If you need to migrate an existing database:

1. **Set Environment Variables**:
   ```bash
   # Create and edit .env file
   cp .env.example .env
   
   # Required variables:
   # - DB_SERVER (from terraform output)
   # - DB_USER (admin username)
   # - DB_PASSWORD (admin password)
   ```

2. **Run Migration**:
   ```bash
   # Source environment variables
   source .env
   
   # Run migration script
   ./migrate.sh
   ```

## Security Best Practices

1. **Password Management**:
   - Use strong, unique passwords
   - Store passwords in Azure Key Vault
   - Never commit passwords to version control

2. **Network Security**:
   - Limit firewall rules to specific IP addresses
   - Use private endpoints when possible
   - Enable SSL/TLS for all connections

3. **Access Control**:
   - Use least privilege principle
   - Regularly rotate credentials
   - Monitor access logs

## Connecting to the Database

After deployment, connect using:
```bash
# Get the server FQDN
SERVER_FQDN=$(terraform output -raw postgresql_flexible_server_fqdn)

# Connect using psql
psql "host=$SERVER_FQDN port=5432 dbname=postgres user=pgadmin password=$ADMIN_PASSWORD sslmode=require"
```

## Maintenance

- Regularly update PostgreSQL version
- Monitor database performance
- Review and update firewall rules
- Rotate credentials periodically

## Troubleshooting

Common issues and solutions:

1. **Connection Issues**:
   - Verify firewall rules
   - Check SSL/TLS configuration
   - Confirm credentials

2. **Migration Problems**:
   - Ensure sufficient storage
   - Check network connectivity
   - Verify source database accessibility

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

