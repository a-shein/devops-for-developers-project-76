.PHONY: prepare deploy vault-edit vault-view

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

# Редактирование зашифрованных секретов (пароль БД и т.п.)
vault-edit:
	ansible-vault edit group_vars/webservers/vault.yml

vault-view:
	ansible-vault view group_vars/webservers/vault.yml
