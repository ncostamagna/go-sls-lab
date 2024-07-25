.PHONY: install, build, terraform
export GOSUMDB=off

install:
	@echo "=> Install service"
	go mod tidy
	go mod download

build:
	@echo "=> Building service"
	env GOOS=linux go build -ldflags="-s -w" -o bin/get/bootstrap			cmd/get/main.go
	cd bin/get && zip -r bootstrap.zip bootstrap

terraform:
	@tflocal -chdir=terraform init
	@tflocal -chdir=terraform apply --auto-approve