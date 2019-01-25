#!/bin/bash
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

sudo yum install -y epel-release git parallel docker htop

sudo dd if=/dev/zero of=/swapfile bs=8M count=1024

sudo mkswap /swapfile

sudo chmod 600 /swapfile

sudo swapon /swapfile

sudo systemctl start docker

git clone https://github.com/keboola/processor-oom-test

cd processor-oom-test
