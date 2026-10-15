# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# Локальная симуляция облачной инфраструктуры проекта:
#   app1, app2  — два сервера с приложением (вместо Yandex Compute Cloud)
#   proxy       — реверс-прокси/балансировщик (вместо Yandex Application Load Balancer)
#   db          — сервер базы данных (вместо Yandex Managed PostgreSQL)
#
# Подготовка (pip/Docker) и деплой выполняются отдельно через `make prepare` /
# `make deploy` (inventory.ini + playbook.yml в корне проекта), а не автоматическим
# Vagrant-провижинером — так это ближе к реальному рабочему процессу с Ansible.

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

      # Пробрасываем порты балансировщика на хост, чтобы открыть приложение в браузере:
      #   redmine_port (http, см. group_vars/all.yml) -> localhost:8080
      #   443 (https, самоподписанный сертификат)      -> localhost:8443
      if name == "proxy"
        node.vm.network "forwarded_port", guest: 8080, host: 8080
        node.vm.network "forwarded_port", guest: 443, host: 8443
      end
    end
  end
end
