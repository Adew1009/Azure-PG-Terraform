#!/bin/bash
set -euo pipefail

# Load env vars if they exist
if [ -f .env ]; then
  source .env
else
  echo "No .env file found. Need ADMIN_PASSWORD and DUMP_FILE defined."
  exit 1
fi

# Make sure we have what we need
if [ -z "${ADMIN_PASSWORD:-}" ] || [ -z "${DUMP_FILE:-}" ]; then
  echo "Missing ADMIN_PASSWORD or DUMP_FILE in .env"
  exit 1
fi

# Grab our IP for the firewall
MY_IP=$(curl -s ifconfig.me)
echo "Using IP: $MY_IP"

# Deploy the infra
echo "Deploying with Terraform..."
terraform init
terraform apply -auto-approve \
  -var="admin_password=$ADMIN_PASSWORD" \
  -var="my_ip=$MY_IP"

# Get the server name
PG_FQDN=$(terraform output -raw postgresql_flexible_server_fqdn)
echo "Server: $PG_FQDN"

# Give it a sec to finish setting up
echo "Waiting for server to be ready..."
sleep 30

# Set PG password for the session
export PGPASSWORD="$ADMIN_PASSWORD"

# Create the DB (ignore if it exists)
echo "Creating DB..."
PGPASSWORD=$ADMIN_PASSWORD psql "host=$PG_FQDN port=5432 user=pgadmin dbname=postgres sslmode=require" \
  -c "CREATE DATABASE nps_db;" || true

# Push our data
echo "Restoring DB..."
PGPASSWORD=$ADMIN_PASSWORD pg_restore \
  --host=$PG_FQDN \
  --port=5432 \
  --username=pgadmin \
  --dbname=nps_db \
  --no-owner \
  --clean \
  --if-exists \
  "$DUMP_FILE"

echo "All set! 🎉"
