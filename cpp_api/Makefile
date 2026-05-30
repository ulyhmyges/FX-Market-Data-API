#.PHONY: build

start: build up api

restart: down rebuild up api

up:
	@echo services postgreSQL and RESTApi BUILD and UP
	@docker builder prune -af
	@docker compose build --no-cache
	@docker compose up -d

down:
	@echo services down
	@docker compose down

build:
	@echo "build..."
	@mkdir build 
	@cmake -S . -B build
	@cmake --build build

clean:
	@echo clean RESTApi project
	@rm -rf build

rebuild: clean build
	@echo "rebuild..."

api:
	@echo ========================================  Run RESTApi ======================================== 
	@./build/RESTApi

