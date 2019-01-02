## Setup

```
yum -y install stress
cd ~
git clone https://github.com/keboola/processor-skip-lines
cd processor-skip-lines
sudo docker build . -t processor-skip-lines
cd ..
git clone https://github.com/keboola/processor-oom-test
cd processor-oom-test
./run.sh
```