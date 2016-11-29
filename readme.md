##Prerequisites

Install azure-cli 2.0 Preview. For Ubnutu 16.04 run following commands in 
terminal, for other OS you can find prerequisites at
https://github.com/Azure/azure-cli/blob/master/doc/preview_install_guide.md#ubuntu-1604-lts


    sudo apt-get update
    sudo apt-get install -y libssl-dev libffi-dev python-dev build-essential
    curl -L https://aka.ms/InstallAzureCli | sudo bash


Then create private ssh key



##Create virtual machine

    az resource group create --name benchmark --location westus
    az vm create --image canonical:UbuntuServer:16.04.0-LTS:latest --size Standard_D3_v2 --storage-type Standard_LRS --admin-username benchmark --ssh-key-value ~/.ssh/id_rsa.pub --public-ip-address-dns-name benchmark-vm1 --resource-group benchmark --location westus --name benchmarkVM1

##Install Custom Script and deploy projects

    azure vm extension set benchmarkResourceGroup benchmarkVM1 CustomScript Microsoft.Azure.Extensions 2.0 --auto-upgrade-minor-version --public-config '{"fileUris": ["https://raw.githubusercontent.com/NetCoreApps/Benchmarking/master/deploy-ss.sh"],"commandToExecute": "./deploy-ss.sh"}'
    az vm extension set -g benchmark --vm-name benchmarkVM1 -n CustomScript --publisher Microsoft.Azure.Extensions --version 2.0 --settings '{"fileUris": ["https://raw.githubusercontent.com/NetCoreApps/Benchmarking/master/deploy-ss.sh"],"commandToExecute": "./deploy-ss.sh"}'

Info about script installation can found at `/var/lib/waagent/custom-script/download/0/` in benchmarkVM1 machine

##Destroy virtual machines

    az vm delete --name benchmarkVM3 --resource-group benchmarkResourceGroup
    az resource group delete --name benchmark

