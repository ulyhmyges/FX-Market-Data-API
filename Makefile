.PHONY: up #Phony targets have the same effect: they are never considered up-to-date

up: down
	@echo docker compose UP
	@docker compose up -d

all: down rm build up

app: down
	@echo compose UP + building $@ 
	@docker compose up -d --build $@

build:
	@echo build containers
	@docker compose build --no-cache

down:
	@echo docker compose down
	@docker compose down --volumes

log:
	@docker compose logs -f

rm:
	@docker compose down --volumes --remove-orphans --rmi all
	@docker builder prune -af


