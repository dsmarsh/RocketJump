
Vagrant.configure("2") do |config|
  wbid = 1473467604

  config.vm.provider "virtualbox" do |v|
    v.gui=false
  end

  ##### DEFINE VM for mgmt #####
  config.vm.define "mgmt" do |device|
    device.vm.hostname = "mgmt"
    device.vm.box = "CumulusCommunity/cumulus-vx"
    device.vm.box_version = "3.2.0"
    device.vm.provider "virtualbox" do |v|
      v.name = "mgmt"
      v.memory = 512
    end

    # Shorten Boot Process - Applies to Ubuntu Only - remove \"Wait for Network\"
    device.vm.provision :shell , inline: "sed -i 's/sleep [0-9]*/sleep 1/' /etc/init/failsafe.conf || true"

    # NETWORK INTERFACES
    device.vm.network "public_network", auto_config: false , :mac => "443839000002"

    # Fixes "stdin: is not a tty" and "mesg: ttyname failed : Inappropriate ioctl for device"  messages --> https://github.com/mitchellh/vagrant/issues/1673
    device.vm.provision :shell , inline: "(grep -q 'mesg n' /root/.profile 2>/dev/null && sed -i '/mesg n/d' /root/.profile && echo 'Ignore the previous error, fixing this now...') || true;"

    # Run the Config specified in the Node Attributes
    device.vm.provision :shell , path: "./mgmt_vm_provision.sh"

  end

end
