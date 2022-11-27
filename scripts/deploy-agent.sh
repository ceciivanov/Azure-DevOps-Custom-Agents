#!/bin/bash

# VMUserName="agentadmin"
# resourceGroup="rg-ey-test"
# scaleSetName="Agent"
# location="northeurope"
# fileName="install-agent.sh"

location=$1
resourceGroup=$2
scaleSetName=$3
VMUserName=$4
fileName=$5
AgentPoolName=$6
AzureDevOpsPAT=$7
AzureDevOpsURL=$8

storageAccount=''; for i in {0..9}; do storageAccount+=$(printf "%x" $(($RANDOM%16)) ); done;
availability=$(az storage account check-name --name $storageAccount --query nameAvailable)

if [ $availability == "true" ]; then
    echo "Create Storage account"

    az storage account create --name $storageAccount --resource-group $resourceGroup --location $location --sku Standard_LRS      
fi

storageKey=$(az storage account keys list --account-name $storageAccount -g $resourceGroup --query "[0].value" -o tsv)
# blobEndpoint=$(az storage account show --name $storageAccount --resource-group $resourceGroup --query primaryEndpoints.blob)

containerName="scripts"

az storage container create --name $containerName --resource-group $resourceGroup  --account-name $storageAccount --account-key "$storageKey" --public-access blob

az storage blob upload --account-key $storageKey --account-name $storageAccount --container-name $containerName --file $fileName

fileUri="https://$storageAccount.blob.core.windows.net/$containerName/$fileName"

az vmss extension set \
    --publisher "Microsoft.Azure.Extensions" \
    --version 2.0 \
    --name customScript \
    --resource-group $resourceGroup \
    --vmss-name $scaleSetName \
    --settings '{"fileUris": ["'${fileUri}'"], "commandToExecute": "bash ./'$fileName' '$AzureDevOpsURL' '$AzureDevOpsPAT' '$AgentPoolName' '$VMUserName'"}'