VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  #config.ssh.port = 497

  config.vm.define "db-master" do |master|
      master.vm.box = "ubuntu/focal64"
      master.vm.network "private_network", ip: "192.168.56.11"
      master.vm.hostname = "db-master"

      master.vm.provider :virtualbox do |vb|
        vb.name = "db-master"
      end

      #master.vm.network "forwarded_port", guest: 3306, host: 3306
      #master.vm.network "forwarded_port", guest: 497, host:497
      master.vm.provision :shell, path: "bootstrap.sh"
      master.vm.provision :shell, path: "master.sh"
  end

  config.vm.define "db-slave" do |slave|
    slave.vm.box = "ubuntu/focal64"
    slave.vm.network "private_network", ip: "192.168.56.12"
    slave.vm.hostname = "db-slave"

    slave.vm.provider :virtualbox do |vb|
      vb.name = "db-slave"
    end

    #slave.vm.network "forwarded_port", guest: 3306, host: 3306
    #slave.vm.network "forwarded_port", guest: 497, host:497
    slave.vm.provision :shell, path: "bootstrap.sh"
    slave.vm.provision :shell, path: "slave.sh"
  end
end
