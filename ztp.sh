#! /bin/bash

# Enable passwordless sudo for cumulus user
echo "cumulus ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/10_cumulus

cat <<EOT > /etc/network/interfaces
auto eth0
iface eth0
  vrf mgmt

auto mgmt
iface mgmt
  address 127.0.0.1/8
  vrf-table auto
EOT
service networking restart

SSH_URL="http://192.168.0.254/authorized_keys"
#Setup SSH key authentication for Ansible
#Setup SSH key for root
mkdir -p /root/.ssh
wget -O /root/.ssh/authorized_keys $SSH_URL
chmod 700 /root/.ssh
chmod 600 /root/.ssh/authorized_keys

#Setup SSH key for cumulus
mkdir -p /home/cumulus/.ssh
chown -R cumulus:cumulus /home/cumulus/.ssh
wget -O /home/cumulus/.ssh/authorized_keys $SSH_URL
chmod 700 /home/cumulus/.ssh
chmod 600 /home/cumulus/.ssh/authorized_keys

# Install cumulus license
sudo cl-license -i http://oob-mgmt-server/cumulus.lic

# Restart switchd for license to take effect
service switchd restart

# Set all ports on the device as admin up
for i in `ls /sys/class/net -1 | grep swp`; do  ip link set up $i; done;

# CUMULUS-AUTOPROVISIONING
exit 0
