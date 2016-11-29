#!/bin/sh
sudo apt-get update
sudo apt-get install -y wrk

#benchmarking
#warm up
wrk -c 256 -t 8 -d 2 http://$1:5050/json/reply/hello?name=world
#benchmarking
wrk -c 256 -t 8 -d 30 http://$1:5050/json/reply/hello?name=world
wrk -c 256 -t 8 -d 30 http://$1:5050/json/reply/hello?name=world
wrk -c 256 -t 8 -d 30 http://$1:5050/json/reply/hello?name=world
wrk -c 256 -t 8 -d 30 http://$1:5050/json/reply/hello?name=world
wrk -c 256 -t 8 -d 30 http://$1:5050/json/reply/hello?name=world
