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
cd /var/www/netcore/Hello/src/WebApp && dotnet restore && nohup dotnet run -c Release > /dev/null 2>&1 & echo $! > hello.pid
