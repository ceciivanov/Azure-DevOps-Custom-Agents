#!/bin/bash


VMUserName=$4

cd /home/$VMUserName

AzureDevOpsURL=$1
AzureDevOpsPAT=$2
AgentPoolName=$3

# define required arguments for the config
# AzureDevOpsPAT=fnnzkwfgwqvdvejobyzuxrmu7rvotu6krrtl5q7ge3426caugaqq
# AzureDevOpsURL=https://dev.azure.com/CIvanov0344
# AgentPoolName=customAgents
# VMadmin=agentadmin

# Creates directory & download ADO agent install files
mkdir myagent && cd myagent

# download the zip for the agent configuration and extract it
wget https://vstsagentpackage.azureedge.net/agent/2.213.2/vsts-agent-linux-x64-2.213.2.tar.gz
tar zxf vsts-agent-linux-x64-2.213.2.tar.gz

chown -R $VMUserName:$VMUserName /home/$VMUserName/myagent

echo "running config.sh"

su - $VMUserName -c "cd /home/$VMUserName/myagent && ./config.sh --unattended \
  --agent ${AZP_AGENT_NAME:-$(hostname)} \
  --url $AzureDevOpsURL \
  --auth PAT \
  --token $AzureDevOpsPAT \
  --pool $AgentPoolName \
  --replace \
  --acceptTeeEula"

cd /home/$VMUserName/myagent

echo "agent configured start service"

# Install and start the agent service
sudo ./svc.sh install
sudo ./svc.sh start