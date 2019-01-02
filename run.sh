#!/bin/bash

echo "Setting up"
rm -rf /tmp/processor-oom-test-0*
mkdir -p /tmp/processor-oom-test-01/tmp
mkdir -p /tmp/processor-oom-test-01/data/in/files
mkdir -p /tmp/processor-oom-test-01/data/in/tables
mkdir -p /tmp/processor-oom-test-01/data/out/files
mkdir -p /tmp/processor-oom-test-01/data/out/tables
cp ./config.json /tmp/processor-oom-test-01/data/config.json

echo "Generating CSV"
# https://stackoverflow.com/questions/29253591/generate-large-csv-with-random-content-in-bash
hexdump -v -e '5/1 "%02x""\n"' /dev/urandom |
  awk -v OFS='\t' '
    NR == 1 { print "foo", "bar", "baz" }
    { print substr($0, 1, 8), substr($0, 9, 2), int(NR * 32768 * rand()) }' |
  head -n 100000000 > /tmp/processor-oom-test-01/data/in/files/source.csv

echo "Duplicating"
cp -r /tmp/processor-oom-test-01/ /tmp/processor-oom-test-02/
cp -r /tmp/processor-oom-test-01/ /tmp/processor-oom-test-03/
cp -r /tmp/processor-oom-test-01/ /tmp/processor-oom-test-04/
cp -r /tmp/processor-oom-test-01/ /tmp/processor-oom-test-05/

echo "Starting logging"
rm -f /tmp/pmap.log && rm -f /tmp/ps.log 
timeout --foreground 1 sh -c './log.sh;:'

echo "Starting stress test"
cd /tmp
timeout --foreground 1 sh -c 'stress --io 50 --hdd 50 --hdd-bytes 10G --timeout 120s;:'

echo "Running 5 containers"
sudo docker run --memory=128m --rm --volume /tmp/processor-oom-test-01/data:/data --volume /tmp/processor-oom-test-01/tmp:/tmp --name processor-oom-test-01 processor-skip-lines & \
sudo docker run --memory=128m --rm --volume /tmp/processor-oom-test-02/data:/data --volume /tmp/processor-oom-test-02/tmp:/tmp --name processor-oom-test-02 processor-skip-lines & \
sudo docker run --memory=128m --rm --volume /tmp/processor-oom-test-03/data:/data --volume /tmp/processor-oom-test-03/tmp:/tmp --name processor-oom-test-03 processor-skip-lines & \
sudo docker run --memory=128m --rm --volume /tmp/processor-oom-test-04/data:/data --volume /tmp/processor-oom-test-04/tmp:/tmp --name processor-oom-test-04 processor-skip-lines & \
sudo docker run --memory=128m --rm --volume /tmp/processor-oom-test-05/data:/data --volume /tmp/processor-oom-test-05/tmp:/tmp --name processor-oom-test-05 processor-skip-lines 