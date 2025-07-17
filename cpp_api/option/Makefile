run: build
	@echo start...
	@./main

build: 
	@echo build...
	@g++ -std=c++17 main.cpp -I ${HOME}/local/include -isystem /opt/homebrew/include  -L${HOME}/local/lib -lQuantLib -o main
