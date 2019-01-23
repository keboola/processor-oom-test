#!/bin/bash

echo "Setting up"
rm -rf $1/oom-test-*
mkdir -p $1/oom-test-template

echo "Generating CSV"
# https://stackoverflow.com/questions/29253591/generate-large-csv-with-random-content-in-bash
hexdump -v -e '5/1 "%02x""\n"' /dev/urandom |
  awk -v OFS='\t' '
    NR == 1 { print "foo", "bar", "baz" }
    { print substr($0, 1, 8), substr($0, 9, 2), int(NR * 32768 * rand()) }' |
  head -n $2 > $1/oom-test-template/source.csv

echo "Duplicating"
for i in `seq -w 1 $3`;
do
  cp -r $1/oom-test-template/ $1/oom-test-$i/
done

echo "Pulling container"
sudo docker pull centos:latest

echo "Running $3 containers"
seq -w 1 $3 | parallel --will-cite --jobs $3 eval time sudo docker run --rm --volume $1/oom-test-{}:/data --volume $(pwd)/tail.sh:/code/tail.sh --name oom-test-{} $4 centos:latest /code/tail.sh

echo "Inspecting $3 containers"
for i in `seq -w 1 $3`;
do
  sudo docker inspect oom-test-$i | grep OOM
  sudo docker rm  oom-test-$i
done
