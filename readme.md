##Prerequisites

Install azure-cli 2.0 Preview. For Ubnutu 16.04 run following commands in 
terminal, for other OS you can find prerequisites at
https://github.com/Azure/azure-cli/blob/master/doc/preview_install_guide.md#ubuntu-1604-lts


    sudo apt-get update
    sudo apt-get install -y libssl-dev libffi-dev python-dev build-essential
    curl -L https://aka.ms/InstallAzureCli | sudo bash


Then create private ssh key



##Create virtual machine

az vm create --image canonical:UbuntuServer:16.04.0-LTS:latest --admin-username bechmark --ssh-key-value ~/.ssh/id_rsa.pub --public-ip-address-dns-name benchmark-vm1 --resource-group benchmarkResourceGroup --location westus --name benchmarkVM1

##Install Custom Script and deploy projects

azure vm extension set benchmarkResourceGroup benchmarkVM1 CustomScript Microsoft.Azure.Extensions 2.0 --auto-upgrade-minor-version --public-config '{"fileUris": ["https://gist.githubusercontent.com/xplicit/378307cda0c31f2cddca75bf97e9df54/raw/9ab567ca2ebb71174c88d770ddcc640edd4b875c/deploy-ss.sh"],"commandToExecute": "./deploy-ss.sh"}'


##Destroy virtual machines
az vm deallocate --name benchmarkVM1 --resource-group benchmarkResourceGroup


