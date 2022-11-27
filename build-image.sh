#!/bin/bash

location="northeurope"
subscriptionId="4b3e8c6e-448a-4a6c-9c1d-106719e46a65"
tenantId="e86449d8-e83e-46ab-80ea-727b54c49daa"
clientId="ebe966bf-9225-4f22-ab29-4b3eecdfec5b"
clientSecret="sPQ8Q~-NtYdXpD~VHNvczYLwthZ1~NtcR6bDkaHp"
packerFile="packer.json"
resourceGroup="rg-ey-test"
imageName="linuxImage"


echo "Create resource group"
az group create -l $location -n $resourceGroup


# install packer
# curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -

# sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

# sudo apt-get update && sudo apt-get install packer

# packer build
echo "Building image with Packer..."

packer build \
    -var "client_id=$clientId" \
    -var "client_secret=$clientSecret" \
    -var "tenant_id=$tenantId" \
    -var "subscription_id=$subscriptionId" \
    -var "location=$location" \
    -var "managed_image_resource_group_name=$resourceGroup" \
    -var "managed_image_name=$imageName" $packerFile