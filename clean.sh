#!/bin/bash

sudo docker stop `sudo docker ps -q -l -f "status=running"`
sudo docker container prune
