Init Actions:

- create azure devops project
- clone the repo to local VScode workspace, copy all the scripts/files
- get the azuredevops URL and store it in a file
- create azure devops personal access token (PAT) and store it's value in a file
- create an azure devops service connection(automated) for the project
- create an service principal with role contributor over the subscription, this is used for the packer builder to create resources in azure
  from the output store the appId and the password in a file
- create a variable group for each pipeline

1. Image-Variables -> 
subscriptionId, tenantId, resourceGroup (name), location, 
clientId (appId from sp), clientSecret (password from sp), managedImageName, packerFile

* Declare a packer.json file with the image customization. This file specifies an inline execute command which can be used to install
software, packages, extension etc. to achieve the customization for your needs.

2. ScaleSet-Variables -> location, resourceGroup, managedImage, VMName, VMUserName, VMUserPassword, ScaleSetName

3. Agent-Variables -> AgentPoolName, AzureDevOpsPAT, AzureDevOpsURL, location, VMUserName, ScaleSetName, FileName (the script install-agent.sh), resourceGroup


----------------------------------------------------------------------------------------------
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