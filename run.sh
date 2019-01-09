#!/bin/bash

echo "Setting up"
rm -rf $1/processor-oom-test-*
mkdir -p $1/processor-oom-test-template/tmp
mkdir -p $1/processor-oom-test-template/data/in/files
mkdir -p $1/processor-oom-test-template/data/in/tables
mkdir -p $1/processor-oom-test-template/data/out/files
mkdir -p $1/processor-oom-test-template/data/out/tables
cp ./config.json $1/processor-oom-test-template/data/config.json

echo "Generating CSV"
# https://stackoverflow.com/questions/29253591/generate-large-csv-with-random-content-in-bash
hexdump -v -e '5/1 "%02x""\n"' /dev/urandom |
  awk -v OFS='\t' '
    NR == 1 { print "foo", "bar", "baz" }
    { print substr($0, 1, 8), substr($0, 9, 2), int(NR * 32768 * rand()) }' |
  head -n $2 > $1/processor-oom-test-template/data/in/files/source.csv

echo "Duplicating"
for i in `seq -w 1 $3`;
do
  cp -r $1/processor-oom-test-template/ $1/processor-oom-test-$i/
done

echo "Starting stress test"
cd $1
timeout --foreground 1 sh -c "stress --io 50 --hdd 50 --hdd-bytes 10G --timeout $4s;:"

echo "Running $3 containers"
seq -w 1 $3 | parallel --will-cite eval time sudo docker run --rm --volume $1/processor-oom-test-{}/data:/data --volume $1/processor-oom-test-{}/tmp:/tmp --name processor-oom-test-{} $5 processor-skip-lines