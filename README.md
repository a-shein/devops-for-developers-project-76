# Деплой Docker-образов с помощью Ansible

[![hexlet-check](https://github.com/a-shein/devops-for-developers-project-76/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/a-shein/devops-for-developers-project-76/actions)

Автоматизация раскатывания контейнеризированного приложения на кластер машин в облаке

Учебный проект Хекслета: https://ru.hexlet.io/programs/devops-for-developers
Как это должно работать: https://asciinema.org/a/v4evn7XjCdou7Yh71IG0ljb0W

## Стек

- Vagrant + VirtualBox — локальная симуляция облачной инфраструктуры (вместо платного облака)
- Ansible — установка Docker и деплой контейнеров на все хосты
- Docker — контейнеризация приложения (Redmine) и базы данных (PostgreSQL)
- Nginx — реверс-прокси / балансировщик нагрузки (аналог Yandex Application Load Balancer)
- PostgreSQL — база данных приложения

## Архитектура

4 виртуальные машины на приватной сети `192.168.56.0/24`, поднимаемые Vagrant:

| Хост    | IP             | Роль                                   |
|---------|----------------|----------------------------------------|
| db      | 192.168.56.13  | PostgreSQL в Docker-контейнере         |
| app1    | 192.168.56.11  | Redmine в Docker-контейнере (порт 80)  |
| app2    | 192.168.56.12  | Redmine в Docker-контейнере (порт 80)  |
| proxy   | 192.168.56.10  | Nginx — балансировщик на app1 + app2   |

Это локальный аналог продакшен-инфраструктуры из курса (два сервера с приложением,
балансировщик нагрузки, кластер БД), развёрнутый через Ansible так же, как это
делается на реальных облачных серверах — только вместо Yandex Compute Cloud/ALB/
Managed PostgreSQL используются VirtualBox-машины.

## Установка

```bash
git clone git@github.com:a-shein/devops-for-developers-project-76.git
cd devops-for-developers-project-76
vagrant up
```

Vagrant поднимет 4 VM и автоматически прогонит `ansible/playbook.yml`, который:
1. Устанавливает Docker на все хосты
2. Разворачивает PostgreSQL на `db`
3. Деплоит Redmine на `app1` и `app2`, подключая к базе на `db`
4. Настраивает Nginx-балансировщик на `proxy`

## Использование

После `vagrant up` приложение доступно на хосте:

```bash
curl http://localhost:8080/
```

Балансировщик (`proxy`) пробрасывает порт 80 своей VM на `localhost:8080` и
распределяет запросы между `app1` и `app2` (round-robin).

---

<details>
<summary>Автоматические тесты Хекслета</summary>

Тесты запускаются на каждый коммит. За запуск отвечает файл `.github/workflows/hexlet-check.yml` — не удаляйте и не переименовывайте ни его, ни репозиторий.

</details>

## О Хекслете

[Хекслет](https://ru.hexlet.io/) — школа программирования: авторские программы обучения с практикой, поддержкой наставников и реальными проектами, которые остаются в резюме. Этот репозиторий — один из таких проектов.
