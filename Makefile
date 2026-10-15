.PHONY: prepare deploy

# Устанавливает роли/коллекции Ansible Galaxy и ставит pip+Docker на все сервера
prepare:
	ansible-galaxy install -r requirements.yml -p roles/
	ansible-galaxy collection install -r requirements.yml
	ansible-playbook playbook.yml --tags prepare

# Полный прогон плейбука: подготовка + деплой БД + деплой приложения + балансировщик
deploy:
	ansible-playbook playbook.yml
