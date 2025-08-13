# Читаем ключ в Ruby
ssh_pub_path = File.expand_path("~/.ssh/id_rsa.pub")


Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-22.04"
  # Указываем версию и отключаем проверку обновлений
  config.vm.box_version = ">= 1.0.0"
  config.vm.box_check_update = false
  # отключаем shared folders
  config.vm.synced_folder ".", "/vagrant", disabled: true
  # Автоматическая установка Guest Additions с плагином vbguest
  config.vbguest.auto_update = true
  config.vbguest.no_remote = false
  # Настройки машины
  config.vm.hostname = "deb-test"
  config.vm.network "private_network", ip: "192.168.10.10"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 2048
    vb.cpus = 2
  end
  # устанавливаем пакеты и обновляем
  config.vm.provision "shell", inline: <<-SHELL
    sudo apt update && sudo apt install -y build-essential curl
  SHELL
  # Передаём файл публичного ключа внутрь VM
  config.vm.provision "file", source: ssh_pub_path, destination: "/tmp/id_rsa.pub"
  # Добавляем SSH ключ через provisioning
  config.vm.provision "shell", inline: <<-SHELL
    mkdir -p /home/vagrant/.ssh
    cat /tmp/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
    chmod 700 /home/vagrant/.ssh
    chmod 600 /home/vagrant/.ssh/authorized_keys
    chown -R vagrant:vagrant /home/vagrant/.ssh
  SHELL
end