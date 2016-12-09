#!/bin/sh
sudo apt-get update > /dev/null
sudo apt-get install -y wrk > /dev/null

#benchmarking
#warm up
wrk -c 256 -t 8 -d 2 http://$1:5050/json/reply/hello?name=world > /dev/null
#benchmarking
echo "Benchmarking .NET Core /json/reply/hello?name=world"
wrk -c 256 -t 8 -d 30 http://$1:5050/json/reply/hello?name=world | grep Requests
wrk -c 256 -t 8 -d 30 http://$1:5050/json/reply/hello?name=world | grep Requests
wrk -c 256 -t 8 -d 30 http://$1:5050/json/reply/hello?name=world | grep Requests
wrk -c 256 -t 8 -d 30 http://$1:5050/json/reply/hello?name=world | grep Requests
wrk -c 256 -t 8 -d 30 http://$1:5050/json/reply/hello?name=world | grep Requests
echo "Benchmarking Mono /json/reply/hello?name=world"
wget http://$1/json/reply/hello?name=world > /dev/null
wrk -c 50 -t 8 -d 2 http://$1/json/reply/hello?name=world > /dev/null
wrk -c 50 -t 8 -d 30 http://$1/json/reply/hello?name=world | grep Requests
wrk -c 50 -t 8 -d 30 http://$1/json/reply/hello?name=world | grep Requests
wrk -c 50 -t 8 -d 30 http://$1/json/reply/hello?name=world | grep Requests
wrk -c 50 -t 8 -d 30 http://$1/json/reply/hello?name=world | grep Requests
wrk -c 50 -t 8 -d 30 http://$1/json/reply/hello?name=world | grep Requests

