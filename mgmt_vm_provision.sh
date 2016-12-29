net add interface swp1 ip address 192.168.0.254/24
net commit

cat <<EOT >> /etc/apt/sources.list
deb http://http.us.debian.org/debian jessie main
deb http://security.debian.org/ jessie/updates main
EOT

echo " ### Updating APT Repository... ###"
apt-get update -y

echo " ### Installing Packages... ###"
apt-get install -y htop isc-dhcp-server tree apache2 git python-pip dnsmasq ansible lldpd
pip install pip --upgrade
pip install setuptools --upgrade
pip install ansible --upgrade

echo " ### Setting Up DHCP ###"
cp /vagrant/dhcpd.conf /etc/dhcp/dhcpd.conf
chmod 755 -R /etc/dhcp/*
systemctl restart dhcpd.service

echo " ### Moving Hostfile ###"
cp /vagrant/hosts /etc/hosts

echo " ### Moving Ansible Hostfile ###"
mkdir -p /etc/ansible
cp /vagrant/ansible_hostfile /etc/ansible/hosts

echo "### Generating SSH Key for root for passwordless ssh logins from this machine ###"
/usr/bin/ssh-keygen -b 2048 -t rsa -f /root/.ssh/id_rsa -q -N ""
echo "Copying Key into /var/www/..."
cp /root/.ssh/id_rsa.pub /var/www/html/authorized_keys
cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

echo " ### Setting up NAT for eth0s to use MGMT VM for internet ###"
/sbin/iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
ifup swp1

echo " ### Moving ZTP into www directory ###"
cp /vagrant/ztp.sh /var/www/html/ztp.sh

echo " ### Moving CL License into www directory ###"
cp /vagrant/cumulus.lic /var/www/html/cumulus.lic

echo " ### Restart DNSMasq ###"
systemctl restart dnsmasq.service

echo "############################################"
echo "      DONE!"
echo "############################################"
