.PHONY: install, build
export GOSUMDB=off

install:
	@echo "=> Install service"
	go mod tidy
	go mod download

build:
	@echo "=> Building service"
	env GOOS=linux go build -ldflags="-s -w" -o bin/get			cmd/get/main.go