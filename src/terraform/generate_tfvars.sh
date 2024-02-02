#!/bin/sh

# Define variables
SUBSCRIPTION_ID=2a10f2dc-21a6-48fd-aa63-bf79b600ba04
MY_CLOUD_PREFIX=cloud24
MY_CLOUD_LOCATION=westeurope

PSQL_PASSWORD=$(openssl rand -base64 20)

# Generate tfvars file
cat > terraform.tfvars << EOF
subscription_id ="$SUBSCRIPTION_ID"

prefix   = "$MY_CLOUD_PREFIX"
location = "$MY_CLOUD_LOCATION"

psql_admin    = "psqladmin"
psql_password = "$PSQL_PASSWORD"
EOF
