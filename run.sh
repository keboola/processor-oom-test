#!/bin/bash
set -e

echo "Setting up"
rm -rf /tmp/processor-oom-test
mkdir -p /tmp/processor-oom-test/tmp
mkdir -p /tmp/processor-oom-test/data/in/files
mkdir -p /tmp/processor-oom-test/data/in/tables
mkdir -p /tmp/processor-oom-test/data/out/files
mkdir -p /tmp/processor-oom-test/data/out/tables
cp ./config.json /tmp/processor-oom-test/data/config.json

echo "Generating CSV"
# https://stackoverflow.com/questions/29253591/generate-large-csv-with-random-content-in-bash
hexdump -v -e '5/1 "%02x""\n"' /dev/urandom |
  awk -v OFS='\t' '
    NR == 1 { print "foo", "bar", "baz" }
    { print substr($0, 1, 8), substr($0, 9, 2), int(NR * 32768 * rand()) }' |
  head -n 100000000 > /tmp/processor-oom-test/data/in/files/source.csv

echo "Running stress & container"
cd /tmp
stress --io 4 --hdd 4 --timeout 20s & sleep 5 && docker run --memory=256m --rm --volume /tmp/processor-oom-test/data:/data --volume /tmp/processor-oom-test/tmp:/tmp processor-skip-lines