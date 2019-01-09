## Setup

```
sudo yum -y install stress parallel
cd ~
git clone https://github.com/keboola/processor-skip-lines
cd processor-skip-lines
sudo docker build . -t processor-skip-lines
cd ..
git clone https://github.com/keboola/processor-oom-test
cd processor-oom-test
./run.sh /tmp 100000000 5 120 "--memory=256m"
```

## Arguments

 1) Folder to store the data
 2) Rows in CSV
 3) Number of containers
 4) Stress test timeout 
 5) Additional `docker run` parameters (optional)

Example

```
./run.sh /tmp 100000000 1 \
"--memory=256m --device-write-bps /dev/nvme0n1:10m --device-read-bps /dev/nvme0n1:10m --device-write-bps /dev/nvme1n1:10m --device-read-bps /dev/nvme1n1:10m --device-write-bps /dev/nvme2n1:10m --device-read-bps /dev/nvme2n1:10m --device-write-bps /dev/nvme3n1:10m --device-read-bps /dev/nvme3n1:10m"
```

## Logging
```
watch -n1 'ps -C /code/main.php -opid --no-heading | xargs sudo pmap -x >> /tmp/pmap.log & ps -C /code/main.php -opid,size,vsize --no-heading >> /tmp/ps.log' 
```