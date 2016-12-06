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
    az vm create --image canonical:UbuntuServer:16.04.0-LTS:latest --size Standard_D3_v2 --storage-type Standard_LRS --admin-username benchmark --ssh-key-value ~/.ssh/id_rsa.pub --public-ip-address-dns-name benchmark-vm2 --resource-group benchmark --location westus --name benchmarkVM2

##Install Custom Script and deploy projects

    INTERNAL_IP=$(az vm list-ip-addresses --name BenchmarkVM1 | jq .[0].virtualMachine.network.privateIpAddresses[0] | sed -e 's/^"//' -e 's/"$//')
    az vm extension set -g benchmark --vm-name benchmarkVM1 -n CustomScript --publisher Microsoft.Azure.Extensions --version 2.0 --settings '{"fileUris": ["https://raw.githubusercontent.com/NetCoreApps/Benchmarking/master/deploy-ss.sh"],"commandToExecute": "./deploy-ss.sh"}'
    az vm extension set -g benchmark --vm-name benchmarkVM1 -n CustomScript --publisher Microsoft.Azure.Extensions --version 2.0 --settings '{"fileUris": ["https://raw.githubusercontent.com/NetCoreApps/Benchmarking/master/deploy-mono.sh"],"commandToExecute": "./deploy-mono.sh '"${INTERNAL_IP}"'"}'

Info about script installation can found at `/var/lib/waagent/custom-script/download/0/` in benchmarkVM1 machine

##Run benchmarks
    
    #az vm extension set -g benchmark --vm-name benchmarkVM2 -n CustomScript --publisher Microsoft.Azure.Extensions --version 2.0 --settings '{"fileUris": ["https://raw.githubusercontent.com/NetCoreApps/Benchmarking/master/benchmark.sh?v1"],"commandToExecute": "./benchmark.sh '"${INTERNAL_IP}"'"}'

    az vm extension set -g benchmark --vm-name benchmarkVM2 -n CustomScriptForLinux --publisher Microsoft.OSTCExtensions --version 1.5 --settings '{"fileUris": ["https://raw.githubusercontent.com/NetCoreApps/Benchmarking/master/benchmark.sh?v1"],"commandToExecute": "./benchmark.sh '"${INTERNAL_IP}"'"}'
    az vm get-instance-view -n benchmarkVM2 -g benchmark | jq '.[] | select(.name == "CustomScriptForLinux").statuses[0].message'

##Destroy virtual machines

    az vm delete --name benchmarkVM3 --resource-group benchmarkResourceGroup
    az resource group delete --name benchmark

