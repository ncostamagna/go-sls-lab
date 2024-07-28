.PHONY: install, build, terraform
export GOSUMDB=off

CONDA_ACTIVATE=source $$(conda info --base)/etc/profile.d/conda.sh ; conda activate ; conda activate


install:
	@echo "=> Install service"
	@go mod tidy
	@go mod download
	@docker compose up -d
	@tflocal -chdir=infra init

build:
	@echo "=> Building service"
	env GOOS=linux go build -ldflags="-s -w" -o infra/bin/get/bootstrap			cmd/get/main.go
	cd infra/bin/get && zip -r bootstrap.zip bootstrap

local:
	@tflocal -chdir=infra apply --auto-approve -var-file=dev.tfvars