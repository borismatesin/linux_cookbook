# Setting up swap

`$SWAP_SIZE=SQRT(RAM size)..(2 * RAM size)`

```
SWAP_SIZE=$(free -m | grep Mem | tr -s ' ' | cut -f2 -d" ")
# should reasonably use between SQRT(SWAP_SIZE) and 2*SWAP_SIZE
dd if=/dev/zero of=/swapfile bs=1MiB count=${SWAP_SIZE}
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "/swapfile swap swap defaults 0 0" >> /etc/fstab
# set to a hair above alerting - alerting at 75%, swappiness at 24 (100 - 75 - 1)
echo "vm.swappiness=24" >> /etc/sysctl.conf
sysctl -p
```
# Who's overusing swap?

```sh
#!/bin/bash
# Get current swap usage for all running processes
# Erik Ljungstrom 27/05/2011
# Modified by Mikko Rantalainen 2012-08-09
# Pipe the output to "sort -nk3" to get sorted output
# Modified by Marc Methot 2014-09-18
# removed the need for sudo

SUM=0
OVERALL=0
for DIR in `find /proc/ -maxdepth 1 -type d -regex "^/proc/[0-9]+"`
do
    PID=`echo $DIR | cut -d / -f 3`
    PROGNAME=`ps -p $PID -o comm --no-headers`
    for SWAP in `grep VmSwap $DIR/status 2>/dev/null | awk '{ print $2 }'`
    do
        let SUM=$SUM+$SWAP
    done
    if (( $SUM > 0 )); then
        echo "PID=$PID swapped $SUM KB ($PROGNAME)"
    fi
    let OVERALL=$OVERALL+$SUM
    SUM=0
done
echo "Overall swap used: $OVERALL KB"
```
