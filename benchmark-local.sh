#!/bin/sh
#reset
wget -qO- http://$1:5051/reset/full &> /dev/null
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
#benchmarking OrmLite
wrk -c 256 -t 8 -d 5 http://$1:5051/db?format=json > /dev/null
echo "Benchmarking .NET Core OrmLite /db"
wrk -c 256 -t 8 -d 5 http://$1:5051/db?format=json | grep Requests
wrk -c 256 -t 8 -d 5 http://$1:5051/db?format=json | grep Requests
wrk -c 256 -t 8 -d 5 http://$1:5051/db?format=json | grep Requests
wrk -c 256 -t 8 -d 5 http://$1:5051/db?format=json | grep Requests
wrk -c 256 -t 8 -d 5 http://$1:5051/db?format=json | grep Requests

