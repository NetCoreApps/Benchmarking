#!/bin/bash
sudo apt-get update
sudo apt-get install -y git
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-xenial-prod xenial main" > /etc/apt/sources.list.d/dotnetdev.list'
sudo apt-get update
sudo apt-get install dotnet-sdk-2.0.0
mkdir -p /var/www/netcore && chown -R www-data:www-data /var/www
su -c "cd /var/www/netcore && git clone -b profiler https://github.com/NetCoreApps/Benchmarking" -s /bin/sh www-data

cd /var/www/netcore/Benchmarking/src
ls -al
HOME=/root dotnet restore
echo "restored"
cd /var/www/netcore/Benchmarking/src/WebApp
HOME=/root dotnet build -c Release
echo "Built"
HOME=/root nohup nice -n 20 dotnet run -c Release > /dev/null 2>&1 & echo $! > hello.pid
echo "End"
