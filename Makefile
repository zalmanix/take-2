USERNAME ?= $(shell getent passwd 30033 | cut -d: -f1)

init:
	mkdir -p ./var/log/supervisor
ifeq ($(filter prod,$(MAKECMDGOALS)),prod)
	docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
else ifeq ($(filter dev,$(MAKECMDGOALS)),dev)
	docker-compose --env-file .env.local -f docker-compose.yml -f docker-compose.dev.yml up -d
else
	@echo "Invalid parameter. Use 'make init prod' or 'make init dev'"
endif
	docker exec -it shopwaredemo-web bash -c "composer install"
	docker exec -it shopwaredemo-web bash -c "./bin/build-storefront.sh"
	chmod -R ug+rwX . -R

start:
ifeq ($(filter prod,$(MAKECMDGOALS)),prod)
	docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d --no-recreate
else ifeq ($(filter dev,$(MAKECMDGOALS)),dev)
	docker-compose --env-file .env.local -f docker-compose.yml -f docker-compose.dev.yml up -d --no-recreate
else
	@echo "Invalid parameter. Use 'make start prod' or 'make start dev'"
endif

stop:
	docker-compose stop

teardown:
	docker-compose down --rmi all -v

sh:
	docker exec -it shopwaredemo-web bash

sh-root:
	docker exec -it --user root shopwaredemo-web bash

build-theme:
	docker exec -it shopwaredemo-web bash -c "./bin/build-storefront.sh"
	docker exec -it shopwaredemo-web bash -c "bin/console cache:clear"
	chmod -R ug+rwX . -R
