#!/bin/bash
# migrate_db.sh - Export local PostgreSQL DB and import to Azure PostgreSQL Flexible Server

# Configuration
LOCAL_DB_NAME="nps_db"
LOCAL_DB_USER="andrew-dew"
DUMP_FILE="${LOCAL_DB_NAME}.dump"

AZURE_DB_NAME="nps_db"
AZURE_DB_USER="pgadmin"
AZURE_DB_PASS="PASSword01"
AZURE_DB_HOST="mypgflexserver5432.postgres.database.azure.com"
AZURE_DB_PORT=5432

# 1. Dump local DB
pg_dump -Fc -h localhost -U $LOCAL_DB_USER $LOCAL_DB_NAME -f $DUMP_FILE

# 2. Create Azure DB (if not exists)
psql "host=$AZURE_DB_HOST port=$AZURE_DB_PORT dbname=postgres user=$AZURE_DB_USER password=$AZURE_DB_PASS sslmode=require" \
  -c "DO $$ BEGIN IF NOT EXISTS (SELECT FROM pg_database WHERE datname = '$AZURE_DB_NAME') THEN CREATE DATABASE \"$AZURE_DB_NAME\"; END IF; END $$;"

# 3. Create role if needed (optional, or handle in pg_restore with --no-owner)
psql "host=$AZURE_DB_HOST port=$AZURE_DB_PORT dbname=$AZURE_DB_NAME user=$AZURE_DB_USER password=$AZURE_DB_PASS sslmode=require" \
  -c "DO $$ BEGIN IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'andrew-dew') THEN CREATE ROLE \"andrew-dew\" NOLOGIN; END IF; END $$;"

# 4. Restore to Azure DB
pg_restore --no-owner -h $AZURE_DB_HOST -p $AZURE_DB_PORT -U $AZURE_DB_USER -d $AZURE_DB_NAME --clean $DUMP_FILE

echo "Migration complete: $LOCAL_DB_NAME -> $AZURE_DB_NAME"

