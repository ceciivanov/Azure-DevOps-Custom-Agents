

location="northeurope"
subscriptionId="4b3e8c6e-448a-4a6c-9c1d-106719e46a65"
tenantId="e86449d8-e83e-46ab-80ea-727b54c49daa"

# command to create service principal to use the azure devops

az ad sp create-for-rbac -n CustomAgentSP --role Contributor --scopes /subscriptions/4b3e8c6e-448a-4a6c-9c1d-106719e46a65

# output ->  appID=clientId  password=clientSecret
{
  "appId": "ebe966bf-9225-4f22-ab29-4b3eecdfec5b",
  "displayName": "CustomAgentSP",
  "password": "sPQ8Q~-NtYdXpD~VHNvczYLwthZ1~NtcR6bDkaHp",
  "tenant": "e86449d8-e83e-46ab-80ea-727b54c49daa"
}

clientId="ebe966bf-9225-4f22-ab29-4b3eecdfec5b"
clientSecret="sPQ8Q~-NtYdXpD~VHNvczYLwthZ1~NtcR6bDkaHp"


packerFile="packer.json"
resourceGroup="rg-ey-test"
imageName="linuxImage01"


