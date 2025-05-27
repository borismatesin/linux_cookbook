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
