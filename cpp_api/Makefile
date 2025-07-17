#.PHONY: build

start: build up api

restart: down rebuild up api

up:
	@echo service postgreSQL up
	@docker compose up --build -d

down:
	@echo service postgreSQL down
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

