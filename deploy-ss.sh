#!/bin/bash
sudo apt-get update
sudo apt-get install -y git
sudo sh -c 'echo "deb [arch=amd64] https://apt-mo.trafficmanager.net/repos/dotnet-release/ xenial main" > /etc/apt/sources.list.d/dotnetdev.list'
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 417A0893
sudo apt-get update
sudo apt-get install -y dotnet-dev-1.0.0-preview2.1-003177
mkdir -p /var/www/netcore && chown -R www-data:www-data /var/www
su -c "cd /var/www/netcore && git clone https://github.com/NetCoreApps/Hello" -s /bin/sh www-data
find /var/www/netcore/Hello -type f -name "Program.cs" -exec sed -i "s/UseStartup<Startup>()/UseStartup<Startup>().UseUrls(\"http:\/\/0.0.0.0:5050\")/g" {} +
find /var/www/netcore/Hello -type f -name "Startup.cs" -exec sed -i "s/loggerFactory/\/\/loggerFactory/g" {} +
find /var/www/netcore/Hello -type f -name "project.json" -exec sed -i "s/\"version\": \"1.0.1\"/\"version\": \"1.1.0\"/g" {} +
find /var/www/netcore/Hello -type f -name "project.json" -exec sed -i "s/netcoreapp1.0/netcoreapp1.1/g" {} +

cd /var/www/netcore/Hello/src/WebApp
ls -al
echo $HOME
cd /var/www/netcore/Hello/src/WebApp && HOME=/root dotnet restore
echo "restored"
cd /var/www/netcore/Hello/src/WebApp && HOME=/root dotnet build -c Release
echo "Built"
HOME=/root nohup dotnet run -c Release > /dev/null 2>&1 & echo $! > hello.pid
echo "End"
