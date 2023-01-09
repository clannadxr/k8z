APP_NAME:=k8z
APP_PATH:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
SCRIPT_PATH:=$(APP_PATH)/scripts
COMPILE_OUT:=$(APP_PATH)/bin/$(APP_NAME)

run:export EGO_DEBUG=true
run:
	@cd $(APP_PATH) && egoctl run
install:export EGO_DEBUG=true
install:
	@cd $(APP_PATH) && go run main.go --config=config/local.toml --job=install

build.darwin:
	@echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>making build app<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
	@chmod +x $(SCRIPT_PATH)/build/*.sh
	@cd $(APP_PATH) &&  GOOS=darwin $(SCRIPT_PATH)/build/gobuild.sh $(APP_NAME) $(COMPILE_OUT)

build.linux:
	@echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>making build app<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
	@chmod +x $(SCRIPT_PATH)/build/*.sh
	@cd $(APP_PATH) &&  GOOS=linux $(SCRIPT_PATH)/build/gobuild.sh $(APP_NAME) $(COMPILE_OUT)

build.api:
	@echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>making build app<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
	@chmod +x $(SCRIPT_PATH)/build/*.sh
	@cd $(APP_PATH) && $(SCRIPT_PATH)/build/gobuild.sh $(APP_NAME) $(COMPILE_OUT)

build.ui:
	@echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>making $@<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
	@git submodule update --init --recursive --remote
	@cd $(APP_PATH)/ui && yarn install --frozen-lockfile && yarn run build
	@cp -r $(APP_PATH)/ui/dist $(APP_PATH)/internal/ui
	@echo -e "\n"


