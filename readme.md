##Prerequisites

Install azure-cli 2.0 Preview. For Ubnutu 16.04 run following commands in 
terminal, for other OS you can find prerequisites at
https://github.com/Azure/azure-cli/blob/master/doc/preview_install_guide.md#ubuntu-1604-lts


    sudo apt-get update
    sudo apt-get install -y curl libssl-dev libffi-dev python-dev build-essential
    curl -L https://aka.ms/InstallAzureCli | sudo bash


Then create private ssh key
   
    ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

Login to azure. You need an active azure subsriction and ability to run at least 8 cores in the region (by default `eastus2` is used)

    az login

##Run benchmarks

To run azure benchmark execute the script:

    ./azure-benchmark.sh

You can change location and machine type by setting `AZ_LOCATION` and `AZ_SIZE` variables in the `azure-benchmark.sh` script. 
Creating virtual machines and benchmarking takes a while (20-40 min). After this you should see benchmarking output, similar to this

    Benchmarking .NET Core /json/reply/hello?name=world
    Requests/sec:  36647.53
    Requests/sec:  37185.99
    Requests/sec:  37257.17
    Requests/sec:  37307.70
    Requests/sec:  36969.34
    Benchmarking .NET Core /plaintext
    Requests/sec:  36492.54
    Requests/sec:  37464.24
    Requests/sec:  36863.77
    Requests/sec:  37643.62
    Requests/sec:  36941.14
    Benchmarking Mono /json/reply/hello?name=world
    Requests/sec:   6787.85
    Requests/sec:   6837.42
    Requests/sec:   6909.75
    Requests/sec:   6766.78
    Requests/sec:   6896.35
    Benchmarking Mono /plaintext
    Requests/sec:   6697.63
    Requests/sec:   6543.59
    Requests/sec:   6319.43
    Requests/sec:   6528.56
    Requests/sec:   6316.96

##Destroy virtual machines

When benchmarking is done you can delete all benchmarking vitual machines and free azure resources

    az group delete --name benchmark

##Benchmark Results

Running 5 benchmarks on Standard_F4s azure instance (4 Core, 8GB RAM). One azure instance is allocated for web application and second for running
`wrk -c 256 -t 8 -d 30 http://benchmarking_url` command.

GET /reply/json/hello?name=world

| Benchmark |      Requests/Sec Average    |  StdDev | StdDev/Average (%) |
|-----------|-----------------------------:|--------:|-------------------:|
| .NET Core 1.1  |  37073                  | 271     | 0.73               |
| mono 4.6.2 (nginx+hyperfasctcgi) |   6840|      63 | 0.93               |

Running 5 benchmarks on Linux desktop
Intel(R) Core(TM) i5-4690K CPU @ 3.50GHz (4 Core, 16GB RAM). Web application and benchmarking program `wrk` run on the same machine.

GET /reply/json/hello?name=world

| Benchmark |      Requests/Sec Average    |  StdDev | StdDev/Average (%) |
|-----------|-----------------------------:|--------:|-------------------:|
| .NET Core 1.1  |  56611                  |     731 | 1.29               |
| mono 4.6.2 (nginx+hyperfasctcgi) | 12841 |     125 | 0.97               |

###Previous results:

| Benchmark |      Requests/Sec Average    |  StdDev | StdDev/Average (%) |
|-----------|-----------------------------:|--------:|-------------------:|
| .NET Core 1.1  |  26179                  | 74      | 0.28               |
| mono 4.6.2 (nginx+hyperfasctcgi) |   6428|      84 | 1.30               |

Running 5 benchmarks on Linux desktop
Intel(R) Core(TM) i5-4690K CPU @ 3.50GHz (4 Core, 16GB RAM). Web application and benchmarking program `wrk` run on the same machine.

GET /reply/json/hello?name=world

| Benchmark |      Requests/Sec Average    |  StdDev | StdDev/Average (%) |
|-----------|-----------------------------:|--------:|-------------------:|
| .NET Core 1.1  |  38343                  |     176 | 0.46               |
| mono 4.6.2 (nginx+hyperfasctcgi) | 11207 |     388 | 3.46               |
