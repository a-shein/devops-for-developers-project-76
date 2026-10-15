# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# Локальная симуляция облачной инфраструктуры проекта:
#   app1, app2  — два сервера с приложением (вместо Yandex Compute Cloud)
#   proxy       — реверс-прокси/балансировщик (вместо Yandex Application Load Balancer)
#   db          — сервер базы данных (вместо Yandex Managed PostgreSQL)

VMS = {
  "db"    => { ip: "192.168.56.13", mem: 768,  cpus: 1 },
  "app1"  => { ip: "192.168.56.11", mem: 768,  cpus: 1 },
  "app2"  => { ip: "192.168.56.12", mem: 768,  cpus: 1 },
  "proxy" => { ip: "192.168.56.10", mem: 512,  cpus: 1 },
}

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"

  VMS.each do |name, opts|
    config.vm.define name do |node|
      node.vm.hostname = name
      node.vm.network "private_network", ip: opts[:ip]

      node.vm.provider "virtualbox" do |vb|
        vb.name = "hexlet-#{name}"
        vb.memory = opts[:mem]
        vb.cpus = opts[:cpus]
      end

      # Проброс 80 порта прокси на хост, чтобы открыть балансер в браузере
      if name == "proxy"
        node.vm.network "forwarded_port", guest: 80, host: 8080
      end

      # Запускаем Ansible один раз, после того как поднимется последняя машина.
      # Vagrant сам построит inventory с нужными группами и ssh-ключами.
      if name == "proxy"
        node.vm.provision "ansible" do |ansible|
          ansible.playbook = "ansible/playbook.yml"
          ansible.limit = "all"
          ansible.become = true
          ansible.groups = {
            "app"      => ["app1", "app2"],
            "dbserver" => ["db"],
            "proxy"    => ["proxy"],
          }
        end
      end
    end
  end
end
