#!/bin/sh
sudo apt-get update > /dev/null
sudo apt-get install -y wrk > /dev/null

#benchmarking
#warm up
wrk -c 256 -t 8 -d 10 http://$1:5051/json/reply/hello?name=world > /dev/null
#benchmarking
echo "Benchmarking .NET Core /json/reply/hello?name=world"
wrk -c 256 -t 8 -d 5 http://$1:5051/json/reply/hello?name=world | grep Requests
wrk -c 256 -t 8 -d 5 http://$1:5051/json/reply/hello?name=world | grep Requests
wrk -c 256 -t 8 -d 5 http://$1:5051/json/reply/hello?name=world | grep Requests
wrk -c 256 -t 8 -d 5 http://$1:5051/json/reply/hello?name=world | grep Requests
wrk -c 256 -t 8 -d 5 http://$1:5051/json/reply/hello?name=world | grep Requests

echo "Benchmarking .NET Core /plaintext"
wrk -c 256 -t 8 -d 5 http://$1:5051/plaintext | grep Requests
wrk -c 256 -t 8 -d 5 http://$1:5051/plaintext | grep Requests
wrk -c 256 -t 8 -d 5 http://$1:5051/plaintext | grep Requests
wrk -c 256 -t 8 -d 5 http://$1:5051/plaintext | grep Requests
wrk -c 256 -t 8 -d 5 http://$1:5051/plaintext | grep Requests

echo "Benchmarking Mono /json/reply/hello?name=world"
wget http://$1/json/reply/hello?name=world > /dev/null
wrk -c 50 -t 8 -d 10 http://$1/json/reply/hello?name=world > /dev/null
wrk -c 50 -t 8 -d 5 http://$1/json/reply/hello?name=world | grep Requests
wrk -c 50 -t 8 -d 5 http://$1/json/reply/hello?name=world | grep Requests
wrk -c 50 -t 8 -d 5 http://$1/json/reply/hello?name=world | grep Requests
wrk -c 50 -t 8 -d 5 http://$1/json/reply/hello?name=world | grep Requests
wrk -c 50 -t 8 -d 5 http://$1/json/reply/hello?name=world | grep Requests

echo "Benchmarking Mono /plaintext"
wrk -c 50 -t 8 -d 10 http://$1/plaintext > /dev/null
wrk -c 50 -t 8 -d 5 http://$1/plaintext | grep Requests
wrk -c 50 -t 8 -d 5 http://$1/plaintext | grep Requests
wrk -c 50 -t 8 -d 5 http://$1/plaintext | grep Requests
wrk -c 50 -t 8 -d 5 http://$1/plaintext | grep Requests
wrk -c 50 -t 8 -d 5 http://$1/plaintext | grep Requests

