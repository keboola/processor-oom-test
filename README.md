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
./run.sh
```

## Logging
```
watch -n1 'ps -C /code/main.php -opid --no-heading | xargs sudo pmap -x >> /tmp/pmap.log & ps -C /code/main.php -opid,size,vsize --no-heading >> /tmp/ps.log' 
```