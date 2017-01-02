#!/bin/sh
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

