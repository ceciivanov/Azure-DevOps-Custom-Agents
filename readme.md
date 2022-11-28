Task: Deploy Azure DevOps Self-Hosted Agents built on Custom (Linux) Images 

Requirements: 
1. Process Implementation (what pipelines are needed, build image, deploy agent etc.)
2. Image Customization (OS kind, VMsize, services, apps, extension running), how the customization will be given to the process 
3. Deploying agents on VMs or VM Scale Set, other configurations for the agents.
4. How to scale up and generalise the whole process, based on customer requirements

Pipelines:
*Current Implementation for each pipeline: - Linux agent & AzureCLI 

1. Build Custom Image and upload it to Azure - using Packer builder (recommended by Microsoft).

source: https://learn.microsoft.com/en-us/azure/virtual-machines/linux/build-image-with-packer 

Packer builder uses a template JSON file that contains the specs of the image and defines a execute command that is used to customise the image with extra packages, services etc 

Implementation: 
- Create resource group
- Install packer on the linux agent running the pipeline
- Define json file and run packer build with the json file


2. Deploy Virtual Machine Scale Set

source: https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/tutorial-use-custom-image-powershell 

- Use the custom image from previous step and deploy a VMSS. 
- Deploy anything required for the scale set (vnet, subnet, loadbalancer, publicIP) 

* default vmss and configuration is used, will change based on the customer needs



3. Deploy self-hosted Azure DevOps Agent 

source: 
- https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/v2-linux?view=azure-devops source: 
- https://learn.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-linux 

Implementation:
- Create Azure Storage Account and upload a script install-agent.sh.
- Define an Azure Virtual Machine Scale set extension that runs the custom script install-agent.sh.
- Configure and install the service to run the agent on each instance of the scale set
