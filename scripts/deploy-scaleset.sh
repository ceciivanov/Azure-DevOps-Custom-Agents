#!/bin/bash

# location="northeurope"
# VMUserName="agentadmin"
# VMUserPassword="Agent001Pa!!"
# VMName="agent"
# resourceGroup="rg-ey-test"
# imageName="linuxImage"
# scaleSetName="Agent"

location=$1
resourceGroup=$2
managedImageName=$3
scaleSetName=$4
VMName=$5
VMUserName=$6
VMUserPassword=$7

echo "Create virtual network and subnet"
az network vnet create \
    --name 'Agent-Vnet' \
    --resource-group $resourceGroup \
    --location $location \
    --address-prefixes '10.0.0.0/16' \
    --subnet-name 'Agent-Subnet' \
    --subnet-prefixes '10.0.0.0/24'

echo "Create public IP"
az network public-ip create \
    --resource-group $resourceGroup \
    --name "LoadBalancerPublicIP" \
    --allocation-method Static \
    --location $location

publicIP=$(az network public-ip show -g rg-ey-test -n LoadBalancerPublicIP --query ipAddress)

echo "Create Load Balancer"
az network lb create \
    --resource-group $resourceGroup \
    --name "Agent-LoadBalancer" \
    --public-ip-address "LoadBalancerPublicIP" \
    --frontend-ip-name "FrontEndPool" \
    --backend-pool-name "BackEndPool"

echo "Create LB Nat-Pool"
az network lb inbound-nat-pool create \
    --resource-group $resourceGroup \
    --frontend-port-range-end 59999 \
    --frontend-port-range-start 50001 \
    --backend-port 22 \
    --name "LB-NatPool" \
    --lb-name "Agent-LoadBalancer" \
    --protocol tcp 

echo "Create Load Balancer Health Probe"
az network lb probe create \
    --resource-group $resourceGroup \
    --lb-name "Agent-LoadBalancer" \
    --name "LB-HealthProbe" \
    --protocol tcp \
    --port 80 \
    --interval 15 \
    --probe-threshold 2

echo "Create Load Balancer Rule"
az network lb rule create \
    --resource-group $resourceGroup \
    --lb-name "Agent-LoadBalancer" \
    --name "LB-Rule" \
    --protocol tcp \
    --frontend-port 80 \
    --backend-port 80 \
    --frontend-ip-name "FrontEndPool" \
    --backend-pool-name "BackEndPool" \
    --probe-name "LB-HealthProbe"

echo "Create VMSS"
az vmss create \
    --resource-group $resourceGroup \
    --name $scaleSetName \
    --location $location \
    --image $managedImageName \
    --instance-count 1 \
    --os-disk-caching "None" \
    --upgrade-policy-mode Automatic \
    --computer-name-prefix $VMName \
    --admin-username $VMUserName \
    --admin-password $VMUserPassword \
    --vnet-name "Agent-Vnet" \
    --subnet "Agent-Subnet" \
    --lb "Agent-LoadBalancer" \
    --backend-pool-name "BackEndPool"