# run as sudo

apt install -y unattended-upgrades
debconf-set-selections <<EOF
unattended-upgrades   unattended-upgrades/enable_auto_updates boolean true
EOF
