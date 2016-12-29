# Laptop Management Server for Initial Configuration

## Install Instructions

### Copy this repo to your laptop
- git clone https://github.com/dsmarsh/RocketJump.git

### Setup Management VM
- From laptop terminal:
 - ls rocketjump
 - vagrant status

#### Copy the 3.2.0 CL image to the VM
- Copy the Cumulus Linux Image to the mgmt VM
 - login and download the x86 version of the CL 3.1.2 image from https://cumulusnetworks.com/downloads/
 - copy that image binary to the ./RocketJump/ directory

#### Change the ansible_hostfile/hosts/ztp.sh/dhcpd.conf to match your environment
- Use nano or vim to edit the files
 - ansible_hostfile
  - hostnames
  - group names
 - hosts
  - ips
  - hostnames
 - ztp.sh
  - passwordless sudo
  - pre-automation /etc/network/interfaces
  - 
 - dhcpd.conf
  -

#### Copy the license string into the license file on the mgmt server.
- Use nano or vim to edit the only line in the cumulus.lic file
 - use vim or nano to open ./RocketJump/cumulus.lic
 - retrieve the license from your email
 - copy and paste the license over the line: <replace this line with license string>
 - save the file and exit vim/nano

#### Boot the mgmt VM
- From the Host running VirtualBox (laptop) - login/password: vagrant/vagrant (not needed)
 - vagrant up
 - vagrant ssh
- Now you will be inside the VM (Cumulus VX). Let's switch to user (su) "root".
 - sudo su
- Now use NCLU to check the version
 - net show version


## Check configuration
#### Apache Hosted
- Check apache hosted files
 - ```
root@mgmt:/home/vagrant# ls -alth /var/www/html/
total 20K
drwxr-xr-x 1 root root  92 Dec 29 03:25 .
-rw-r--r-- 1 root root   0 Dec 29 03:25 cumulus.lic
-rw-r--r-- 1 root root 997 Dec 29 03:25 ztp.sh
-rw-r--r-- 1 root root 391 Dec 29 03:25 authorized_keys
-rw-r--r-- 1 root root 11K Dec 29 03:25 index.html
drwxr-xr-x 1 root root   8 Dec 29 03:25 ..
```
- Check DHCP config
 - ```
root@mgmt:/home/vagrant# ls -alth /etc/dhcp/
total 8.0K
-rwxr-xr-x 1 root root 4.0K Dec 29 03:25 dhcpd.conf
drwxr-xr-x 1 root root 3.5K Dec 29 03:25 ..
drwxr-xr-x 1 root root  134 Dec 14 03:12 dhclient-exit-hooks.d
drwxr-xr-x 1 root root  132 Dec 14 03:12 .
drwxr-xr-x 1 root root   10 Dec 14 03:10 dhclient-enter-hooks.d
-rwxr-xr-x 1 root root 1.9K Dec  2 17:33 dhclient.conf
```




## Follow switches as they boot
#### Two Files to Watch
- Locations
 - /var/log/syslog
 - /var/log/apache2/access.log
- Tail both files at once.
 - tail -f /var/log/syslog /var/log/apache2/access.log
