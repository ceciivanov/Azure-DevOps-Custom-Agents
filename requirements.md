New Azure DevOps Project: Build-Custom-Agents

1. clone GitRepo -> Repo password = 4vwrgwy2y4jwdomodmr5eezbffvf4qw2shmi3fozsl3jzx3lbjoq
2. PAT (Personal Access Token) = fnnzkwfgwqvdvejobyzuxrmu7rvotu6krrtl5q7ge3426caugaqq
3. AzureDevOps URL = https://dev.azure.com/CIvanov0344
4. Create a service connection (using ServicePrincipal)

Specify Variables:

- tenantId = "e86449d8-e83e-46ab-80ea-727b54c49daa"
- subscriptionId = "4b3e8c6e-448a-4a6c-9c1d-106719e46a65"
- location = "northeurope"
- resourceGroup = "rg-ey-test"

run: 
az ad sp create-for-rbac -n CustomAgentSP --role Contributor --scopes /subscriptions/4b3e8c6e-448a-4a6c-9c1d-106719e46a65

# output ->  appID=clientId  password=clientSecret
{
  "appId": "ebe966bf-9225-4f22-ab29-4b3eecdfec5b",
  "displayName": "CustomAgentSP",
  "password": "sPQ8Q~-NtYdXpD~VHNvczYLwthZ1~NtcR6bDkaHp",
  "tenant": "e86449d8-e83e-46ab-80ea-727b54c49daa"
}

- clientId = "ebe966bf-9225-4f22-ab29-4b3eecdfec5b"
- clientSecret = "sPQ8Q~-NtYdXpD~VHNvczYLwthZ1~NtcR6bDkaHp"

- imageName = linuxImage01

- packerFile = packer.json