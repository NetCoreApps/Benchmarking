SET AZ_LOCATION=eastus2
SET AZ_SIZE=Standard_F4s

call azure group create --name benchmark --location %AZ_LOCATION%
call azure network vnet create --resource-group benchmark --name vnet-benchmark --location %AZ_LOCATION%
call azure network vnet subnet create -g benchmark --vnet-name vnet-benchmark --name subnet-benchmark --address-prefix "10.0.0.0/8"

echo "Create Azure instance for Web Application"
call azure vm create --image-urn canonical:UbuntuServer:16.04.0-LTS:latest --vm-size %AZ_SIZE% --storage-account-type Standard_LRS --admin-username benchmark --generate-ssh-keys --resource-group benchmark --nic-name nic-benchmark --vnet-name vnet-benchmark --vnet-subnet-name subnet-benchmark --location %AZ_LOCATION% --os-type Linux --name benchmarkVM1
echo "Create Azure instance for benchmark runner"
call azure vm create --image-urn canonical:UbuntuServer:16.04.0-LTS:latest --vm-size %AZ_SIZE% --storage-account-type Standard_LRS --admin-username benchmark --generate-ssh-keys --resource-group benchmark --nic-name nic2-benchmark --vnet-name vnet-benchmark --vnet-subnet-name subnet-benchmark --location %AZ_LOCATION% --os-type Linux --name benchmarkVM2

REM Install Custom Script and deploy projects

for /f "tokens=3 delims=:" %%i in ('azure network nic show -g benchmark nic-benchmark ^| findstr /C:"Private IP address"') do SET INTERNAL_IP=%%i
for /f "tokens=1" %%i in ("%INTERNAL_IP%") do SET INTERNAL_IP=%%i

echo "Deploying .NET Core app"
call azure vm extension set -g benchmark --vm-name benchmarkVM1 -n CustomScript --publisher-name Microsoft.Azure.Extensions --version 2.0 --public-config "{""fileUris"": [""https://raw.githubusercontent.com/NetCoreApps/Benchmarking/profiler/deploy-ss.sh""],""commandToExecute"": ""./deploy-ss.sh""}"
echo "Deploying mono app"
call azure vm extension set -g benchmark --vm-name benchmarkVM1 -n CustomScript --publisher-name Microsoft.Azure.Extensions --version 2.0 --public-config "{""fileUris"": [""https://raw.githubusercontent.com/NetCoreApps/Benchmarking/profiler/deploy-mono.sh""],""commandToExecute"": ""./deploy-mono.sh %INTERNAL_IP%""}"

REM Info about script installation can found at `/var/lib/waagent/custom-script/download/0/` in benchmarkVM1 machine
REM Run benchmarks

echo "Starting Benchmarking..."
call azure vm extension set -g benchmark --vm-name benchmarkVM2 -n CustomScriptForLinux --publisher-name Microsoft.OSTCExtensions --version 1.5 --public-config "{""fileUris"": [""https://raw.githubusercontent.com/NetCoreApps/Benchmarking/profiler/benchmark.sh?v1""],""commandToExecute"": ""./benchmark.sh %INTERNAL_IP%""}"

@echo off
setlocal EnableDelayedExpansion
for /f "tokens=*" %%i in ('azure vm get-instance-view -n benchmarkVM2 -g benchmark') do (
 IF "%%i" == "---stdout---" (
   SET DO_PRINT=1
 ) ELSE IF "%%i" == "---errout---" (
   SET DO_PRINT=0
 ) ELSE IF !DO_PRINT! == 1 echo %%i
)

REM Destroy virtual machines

REM azure group delete --name benchmark
