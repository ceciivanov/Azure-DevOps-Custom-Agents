Deploy Azure DevOps Self-Hosted Agents using Custom Linux Images

Pipelines:

Current Implementation:
- Linux agent & AzureCLI

1. Build Custom Image to Azure - using Packer builder (recommended by Microsoft).

source: https://learn.microsoft.com/en-us/azure/virtual-machines/linux/build-image-with-packer 

Packer builder uses a template JSON file that contains the specs of the image and defines a execute command that is used to customise the image with extra packages, services etc

Implementation: 
- Create resource group
- Define json file and packer build .json

** Microsoft also recommends Azure Image Builder which is built on Packer (other solution)

2. Deploy Virtual Machine Scale Set

source: https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/tutorial-use-custom-image-powershell

Use the custom image from previous step and deploy a VMSS. Deploy anything required for the scale set (vnet, subnet, loadbalancer, publicIP)

* Bicep implementation is possible

3. Deploy self-hosted Azure DevOps Agent

source: https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/v2-linux?view=azure-devops
source: https://learn.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-linux

Implementation:

- Create Azure Storage Account and upload a script install-agent.sh to a blob file.
- Define an Azure VMSS extension that runs the install-agent.sh

* Current implementation is installing the agent for each instance in the VM scale set.

Install-Agent.sh IScript steps: 
- Download zip provided from azure devops site -> agent pools -> self-hosted agent
- Run configure.sh with required arguments
- Install and start service to activate the agent (svc.sh)