## Setup

```
sudo yum -y install parallel
cd ~
git clone https://github.com/keboola/processor-oom-test
cd processor-oom-test
./run.sh /tmp 100000000 20 "--memory=64m"
```

## Arguments

 1) Folder to store the data
 2) Rows in CSV
 3) Number of containers
 4) Additional `docker run` parameters (optional)
