#!/bin/bash

# Create all needed resources in azure
export TF_VAR_region=""
export TF_VAR_sqlpassword=""
export TF_VAR_start_ip_address=$(hostname -I | awk '{print $1}')
export TF_VAR_end_ip_address=$(hostname -I | awk '{print $1}')
terraform init
terraform plan -out "main.tfplan"
terraform apply "main.tfplan"
PREFIX=$(terraform state show random_string.random | grep "id")
export AZURE_SEARCH_KEY=$(az search admin-key show --resource-group aisearch-sql-integrated --service-name ${PREFIX}-aisearch --query primaryKey -o tsv)
export AZURE_SEARCH_ENDPOINT="https://${PREFIX}-aisearch.search.windows.net"
export AZURE_SEARCH_INDEX_NAME="aiindex"
export SQL_SERVER_NAME="${PREFIX}-sqlserver-hybrid"
export SQL_DATABASE_NAME="sqldb-hybrid"
export SQL_USERNAME=$(az sql server show --name ${PREFIX}-sqlserver-hybrid --resource-group aisearch-sql-integrated --query administratorLogin -o tsv)
export SQL_PASSWORD=""
export SQL_DRIVER=""
export OPENAI_API_KEY=$(az cognitiveservices account keys list --name ${PREFIX}-openaiaccount --resource-group aisearch-sql-integrated --query primaryKey -o tsv)
export OPENAI_API_TYPE="azure"
export OPENAI_URI="https://${PREFIX}-openaiaccount.openai.azure.com/"
export OPENAI_DEPLOYMENT="text-embedding-ada-002"
cd ..

# Run Pyhon script
python3 main.py



