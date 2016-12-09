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
    az vm create --image canonical:UbuntuServer:16.04.0-LTS:latest --size Standard_F4s --storage-type Standard_LRS --admin-username benchmark --ssh-key-value ~/.ssh/id_rsa.pub --public-ip-address-dns-name benchmark-vm1 --resource-group benchmark --location westus --name benchmarkVM1
    az vm create --image canonical:UbuntuServer:16.04.0-LTS:latest --size Standard_F4s --storage-type Standard_LRS --admin-username benchmark --ssh-key-value ~/.ssh/id_rsa.pub --public-ip-address-dns-name benchmark-vm2 --resource-group benchmark --location westus --name benchmarkVM2

##Install Custom Script and deploy projects

    INTERNAL_IP=$(az vm list-ip-addresses --name BenchmarkVM1 | jq .[0].virtualMachine.network.privateIpAddresses[0] | sed -e 's/^"//' -e 's/"$//')
    az vm extension set -g benchmark --vm-name benchmarkVM1 -n CustomScript --publisher Microsoft.Azure.Extensions --version 2.0 --settings '{"fileUris": ["https://raw.githubusercontent.com/NetCoreApps/Benchmarking/master/deploy-ss.sh"],"commandToExecute": "./deploy-ss.sh"}'
    az vm extension set -g benchmark --vm-name benchmarkVM1 -n CustomScript --publisher Microsoft.Azure.Extensions --version 2.0 --settings '{"fileUris": ["https://raw.githubusercontent.com/NetCoreApps/Benchmarking/master/deploy-mono.sh"],"commandToExecute": "./deploy-mono.sh '"${INTERNAL_IP}"'"}'

Info about script installation can found at `/var/lib/waagent/custom-script/download/0/` in benchmarkVM1 machine

##Run benchmarks
    
    #az vm extension set -g benchmark --vm-name benchmarkVM2 -n CustomScript --publisher Microsoft.Azure.Extensions --version 2.0 --settings '{"fileUris": ["https://raw.githubusercontent.com/NetCoreApps/Benchmarking/master/benchmark.sh?v1"],"commandToExecute": "./benchmark.sh '"${INTERNAL_IP}"'"}'

    az vm extension set -g benchmark --vm-name benchmarkVM2 -n CustomScriptForLinux --publisher Microsoft.OSTCExtensions --version 1.5 --settings '{"fileUris": ["https://raw.githubusercontent.com/NetCoreApps/Benchmarking/master/benchmark.sh?v1"],"commandToExecute": "./benchmark.sh '"${INTERNAL_IP}"'"}'
    az vm get-instance-view -n benchmarkVM2 -g benchmark | jq '.instanceView.extensions[] | select(.name == "CustomScriptForLinux").statuses[0].message'

##Destroy virtual machines

    az vm delete --name benchmarkVM3 --resource-group benchmarkResourceGroup
    az resource group delete --name benchmark

##Benchmark Results

Running 5 benchmarks on Standard_F4s azure instance (4 Core, 8Mb RAM). One azure instance is allocated for web application and second for running
`wrk -c 256 -t 8 -d 30 http://benchmarking_url` command.

GET /reply/json/hello?name=world

| Benchmark |      Requests/Sec Average    |  StdDev | StdDev/Average (%) |
|-----------|-----------------------------:|--------:|-------------------:|
| .NET Core 1.1  |  26179                  | 74      | 0.28               |
| mono 4.6.2 (nginx+hyperfasctcgi) |   6428|      84 | 1.30               |

Running 5 benchmarks on Linux desktop
Intel(R) Core(TM) i5-4690K CPU @ 3.50GHz (4 Core, 16Mb RAM). Web application and benchmarking program `wrk` run on the same machine.

GET /reply/json/hello?name=world

| Benchmark |      Requests/Sec Average    |  StdDev | StdDev/Average (%) |
|-----------|-----------------------------:|--------:|-------------------:|
| .NET Core 1.1  |  38343                  |     176 | 0.46               |
| mono 4.6.2 (nginx+hyperfasctcgi) | 11207 |     388 | 3.46               |
