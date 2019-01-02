#!/bin/bash
timeout --signal 9 130 watch -n1 'ps -C /code/main.php -opid --no-heading | xargs sudo pmap -x >> /tmp/pmap.log & ps -C /code/main.php -opid,size,vsize --no-heading >> /tmp/ps.log' 