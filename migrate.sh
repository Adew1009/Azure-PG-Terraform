#!/bin/bash
set -e

# Bail if we're missing required env vars
if [ -z "$DB_SERVER" ] || [ -z "$DB_USER" ] || [ -z "$DB_PASSWORD" ]; then
    echo "Missing required env vars. Need:"
    echo "  DB_SERVER    - DB hostname"
    echo "  DB_USER      - DB username"
    echo "  DB_PASSWORD  - DB password"
    exit 1
fi

# Config
SERVER="$DB_SERVER"
USER="$DB_USER"
PASS="$DB_PASSWORD"
LOCAL_DB="nps_db"
REMOTE_DB="nps_db"
DUMP_FILE="nps_db.dump"

# Set PG password for non-interactive use
export PGPASSWORD=$PASS

# Dump our local DB
echo "Dumping local DB..."
pg_dump -Fc $LOCAL_DB -f $DUMP_FILE

# Create DB on Azure if it doesn't exist
echo "Creating DB on Azure..."
psql "host=$SERVER port=5432 dbname=postgres user=$USER password=$PASS sslmode=require" \
  -c "CREATE DATABASE $REMOTE_DB;" || true

# Push the dump to Azure
echo "Restoring to Azure..."
pg_restore -Fc --no-owner --dbname=$REMOTE_DB \
  "host=$SERVER port=5432 user=$USER password=$PASS sslmode=require"

echo "Done! 🎉"
