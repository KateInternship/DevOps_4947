# -*- mode: ruby -*-
Vagrant.configure("2") do |config|
  config.vm.box = "generic/alpine38"
  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"

  (1..3).each do |i|
    config.vm.define "sftp#{i}" do |vm|
      vm.vm.hostname = "sftp#{i}"
      vm.vm.network "private_network", ip: "192.168.198.#{i + 1}"

      vm.vm.provider "virtualbox" do |vb|
        vb.memory = 512
        vb.cpus   = 1
      end

     
      vm.vm.provision "shell",
        name: "gen_keys",
        path: "scripts/generate_keys.sh",
        privileged: true,
        run: "once"

      
      vm.vm.provision "shell",
        name: "install_keys",
        path: "scripts/install_keys.sh",
        privileged: true,
        run: "never"
    end
  end
end
