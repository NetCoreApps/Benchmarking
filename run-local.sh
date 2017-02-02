#!/bin/sh
ROOT_DIR=~/performance
cd $ROOT_DIR
rm -r benchmarking
git clone -b profiler https://github.com/NetCoreApps/benchmarking
cp -r lib benchmarking/lib
cd benchmarking
dotnet restore
cd src/WebApp
nohup nice -n 20 dotnet run -c Release & echo $! > run.pid
sleep 5
cd ../..
nice -n 19 ./benchmark-local.sh localhost
PID=$(cat src/WebApp/run.pid)
kill -- -$(ps -p $PID -o  "%r" | sed -n '2p')
