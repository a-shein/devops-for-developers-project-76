# Деплой Docker-образов с помощью Ansible

[![hexlet-check](https://github.com/a-shein/devops-for-developers-project-76/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/a-shein/devops-for-developers-project-76/actions)

Автоматизация раскатывания контейнеризированного приложения на кластер машин в облаке

Учебный проект Хекслета: https://ru.hexlet.io/programs/devops-for-developers

## Стек

- Vagrant + VirtualBox — локальная симуляция облачной инфраструктуры (вместо платного облака)
- Ansible (+ Ansible Galaxy роли `geerlingguy.pip`, `geerlingguy.docker`, коллекция `community.docker`)
- Docker — контейнеризация приложения (Redmine) и базы данных (PostgreSQL)
- Nginx — реверс-прокси / балансировщик нагрузки (аналог Yandex Application Load Balancer)
- PostgreSQL — база данных приложения

## Архитектура

4 виртуальные машины на приватной сети `192.168.56.0/24`, поднимаемые Vagrant:

| Хост    | IP             | Группа inventory | Роль                                   |
|---------|----------------|------------------|-----------------------------------------|
| db      | 192.168.56.13  | dbservers        | PostgreSQL в Docker-контейнере          |
| app1    | 192.168.56.11  | webservers       | Redmine в Docker-контейнере (порт 80)   |
| app2    | 192.168.56.12  | webservers       | Redmine в Docker-контейнере (порт 80)   |
| proxy   | 192.168.56.10  | proxy            | Nginx — балансировщик на app1 + app2    |

Это локальный аналог продакшен-инфраструктуры из курса (два сервера с приложением,
балансировщик нагрузки, кластер БД): вместо Yandex Compute Cloud / Application Load
Balancer / Managed PostgreSQL используются VirtualBox-машины, разворачиваемые тем же
Ansible-плейбуком, что применялся бы и для реальных серверов.

## Установка

Зависимости: [Vagrant](https://www.vagrantup.com/), [VirtualBox](https://www.virtualbox.org/),
[Ansible](https://docs.ansible.com/) (с коллекцией `community.docker`).

```bash
git clone git@github.com:a-shein/devops-for-developers-project-76.git
cd devops-for-developers-project-76

# Поднять 4 виртуальные машины (db, app1, app2, proxy)
vagrant up

# Установить роли/коллекции Ansible Galaxy и подготовить сервера (pip + Docker)
make prepare
```

## Использование

Полный деплой (БД + приложение + балансировщик):

```bash
make deploy
```

После деплоя приложение доступно на хосте:

```bash
curl http://localhost:8080/
```

Балансировщик (`proxy`) пробрасывает порт 80 своей VM на `localhost:8080` хоста и
распределяет запросы между `app1` и `app2` (round-robin).

Пароль пользователя БД передаётся через переменную окружения `HEXLET_DB_PASSWORD`
(если не задана — используется дефолт для локальной разработки).

### Файлы

- `playbook.yml` — основной плейбук (`hosts: all`): подготовка окружения, деплой БД,
  деплой приложения, деплой балансировщика
- `inventory.ini` — группы хостов `webservers`, `dbservers`, `proxy`
- `requirements.yml` — роли и коллекции Ansible Galaxy
- `group_vars/all.yml` — общие переменные (пакеты для `geerlingguy.pip`)
- `templates/` — Jinja2-шаблоны (env-файл Redmine, конфиг Nginx)
- `Makefile` — команды `prepare` и `deploy`

---

<details>
<summary>Автоматические тесты Хекслета</summary>

Тесты запускаются на каждый коммит. За запуск отвечает файл `.github/workflows/hexlet-check.yml` — не удаляйте и не переименовывайте ни его, ни репозиторий.

</details>

## О Хекслете

[Хекслет](https://ru.hexlet.io/) — школа программирования: авторские программы обучения с практикой, поддержкой наставников и реальными проектами, которые остаются в резюме. Этот репозиторий — один из таких проектов.
