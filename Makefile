.PHONY: prepare deploy

# Устанавливает роли/коллекции Ansible Galaxy и ставит pip+Docker на все сервера.
# Настройки серверов не трогаются командой deploy.
prepare:
	ansible-galaxy install -r requirements.yml -p roles/
	ansible-galaxy collection install -r requirements.yml
	ansible-playbook playbook.yml --tags prepare

# Запускает только приложение: БД, Redmine на серверах, балансировщик.
# Настройки серверов (pip/Docker) не меняет.
deploy:
	ansible-playbook playbook.yml --tags deploy
