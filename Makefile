.PHONY: up

up: down
	@echo docker compose UP
	@docker builder prune -af
	@docker compose build --no-cache
	@docker compose up -d

down:
	@echo docker compose down --volumes --rmi --remove-orphans --dry-run
	@docker compose down

log:
	@docker compose logs -f
