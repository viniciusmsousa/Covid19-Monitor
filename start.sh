#!/bin/bash
docker stop covid19_monitor
docker rm covid19_monitor
docker ps
docker rmi --force viniciusmsousa/covid19-monitor:0.1
docker ps -a
docker images
docker build -t viniciusmsousa/covid19-monitor:0.1 .
docker run --restart unless-stopped -d -p 3838:3838 --name covid19_monitor viniciusmsousa/covid19-monitor:0.1
docker ps
