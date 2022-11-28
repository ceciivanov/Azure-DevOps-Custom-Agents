#!/bin/bash

location=$1
subscriptionId=$2
tenantId=$3
clientId=$4
clientSecret=$5
resourceGroup=$6
packerFile=$7
managedImageName=$8

echo "Create resource group"
az group create -l $location -n $resourceGroup

# install packer
echo "Install Packer on machine"

curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -

sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

sudo apt-get update && sudo apt-get install packer

packer --version

# packer build
echo "Building image with Packer..."

packer build \
    -var "client_id=$clientId" \
    -var "client_secret=$clientSecret" \
    -var "tenant_id=$tenantId" \
    -var "subscription_id=$subscriptionId" \
    -var "location=$location" \
    -var "managed_image_resource_group_name=$resourceGroup" \
    -var "managed_image_name=$managedImageName" ./imageTemplate/$packerFile
