#!/bin/sh

# Define variables
SUBSCRIPTION_ID=72bd4a4b-1111-2222-3333-7f7f74260b75
MY_CLOUD_PREFIX=cloud22
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
