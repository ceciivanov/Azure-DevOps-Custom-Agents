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

run: 
az ad sp create-for-rbac -n CustomAgentSP --role Contributor --scopes /subscriptions/$(subscriptionScope)
