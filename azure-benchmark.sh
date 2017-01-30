#!/bin/bash

AZ_LOCATION=eastus2
AZ_SIZE=Standard_F4s

az group create --name benchmark --location ${AZ_LOCATION}
echo "Create Azure instance for Web Application"
az vm create --image canonical:UbuntuServer:16.04.0-LTS:latest --size ${AZ_SIZE} --storage-type Standard_LRS --admin-username benchmark --ssh-key-value ~/.ssh/id_rsa.pub --public-ip-address-dns-name benchmark-vm1 --resource-group benchmark --location ${AZ_LOCATION} --name benchmarkVM1
echo "Create Azure instance for benchmark runner"
az vm create --image canonical:UbuntuServer:16.04.0-LTS:latest --size ${AZ_SIZE} --storage-type Standard_LRS --admin-username benchmark --ssh-key-value ~/.ssh/id_rsa.pub --public-ip-address-dns-name benchmark-vm2 --resource-group benchmark --location ${AZ_LOCATION} --name benchmarkVM2

#Install Custom Script and deploy projects

INTERNAL_IP=$(az vm list-ip-addresses --name BenchmarkVM1 | jq .[0].virtualMachine.network.privateIpAddresses[0] | sed -e 's/^"//' -e 's/"$//')
echo "Deploying .NET Core app"
az vm extension set -g benchmark --vm-name benchmarkVM1 -n CustomScript --publisher Microsoft.Azure.Extensions --version 2.0 --settings '{"fileUris": ["https://raw.githubusercontent.com/NetCoreApps/Benchmarking/profiler/deploy-ss.sh"],"commandToExecute": "./deploy-ss.sh"}'
echo "Deploying mono app"
az vm extension set -g benchmark --vm-name benchmarkVM1 -n CustomScript --publisher Microsoft.Azure.Extensions --version 2.0 --settings '{"fileUris": ["https://raw.githubusercontent.com/NetCoreApps/Benchmarking/profiler/deploy-mono.sh"],"commandToExecute": "./deploy-mono.sh '"${INTERNAL_IP}"'"}'

#Info about script installation can found at `/var/lib/waagent/custom-script/download/0/` in benchmarkVM1 machine
#Run benchmarks

echo "Starting Benchmarking..."
az vm extension set -g benchmark --vm-name benchmarkVM2 -n CustomScriptForLinux --publisher Microsoft.OSTCExtensions --version 1.5 --settings '{"fileUris": ["https://raw.githubusercontent.com/NetCoreApps/Benchmarking/profiler/benchmark.sh?v1"],"commandToExecute": "nice -n 20 ./benchmark.sh '"${INTERNAL_IP}"'"}'
az vm get-instance-view -n benchmarkVM2 -g benchmark | jq '.instanceView.extensions[] | select(.name == "CustomScriptForLinux").statuses[0].message' | awk -v FS="(---stdout---|---errout---)" '{print $2}' | sed 's/\\n/\'$'\n''/g'
#Destroy virtual machines

#az group delete --name benchmark
