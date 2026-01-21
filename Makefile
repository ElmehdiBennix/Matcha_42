# ======================================================================================
# GENERAL CONFIGURATION
# ======================================================================================

RED     := \033[0;31m
GREEN   := \033[0;32m
YELLOW  := \033[1;33m
BLUE    := \033[0;34m
NC      := \033[0m
### END COLOR CONFIG

# ======================================================================================
# docker compose configuration
# ======================================================================================

COMPOSE_PROJECT := matcha_42

COMPOSE_BASE := docker-compose.yml
COMPOSE_DEV  := docker-compose.override.yml
COMPOSE_PROD := docker-compose.prod.yml

COMPOSE_ENV := versioning.env

# ======================================================================================
# ENVIRONMENT SELECTION
# Usage: make <target> env=prod
# ======================================================================================
.DEFAULT_GOAL := help

ifeq ($(env),prod)
    COMPOSE_FILE := $(COMPOSE_PROD)
    MODE_MSG     := "🚨 PRODUCTION MODE"
else
    COMPOSE_FILE := $(COMPOSE_DEV)
    MODE_MSG     := "🛠️  DEVELOPMENT MODE"
endif

# Alert user of mode on every run
$(info Current Environment: $(MODE_MSG) [File: $(COMPOSE_FILE)])

COMPOSE := docker compose -f "$(COMPOSE_BASE)" -f "$(COMPOSE_FILE)" -p "$(COMPOSE_PROJECT)" --env-file "$(COMPOSE_ENV)"

# ======================================================================================
# HELP & GENERAL USAGE
# ======================================================================================

help:
	@echo -e "$(BLUE)Chatlilo Makefile Utility$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

compose:
	@$(COMPOSE) $(filter-out $@,$(MAKECMDGOALS))

# ======================================================================================

all: up ## Start the stack (alias for up)

clean: ## remove volumes and down services
	@echo -e "$(YELLOW)Powering Down ... Removing volumes$(NC)"
	@$(COMPOSE) down -v --remove-orphans

fclean: ## Stop services, remove volumes and orphan containers and images
	@echo -e "$(RED)Deep cleaning environment...$(NC)"
	@$(COMPOSE) down -v --rmi all --remove-orphans
	@echo -e "$(GREEN)Environment cleaned up.$(NC)"

re: clean up ## Rebuild and restart from scratch

# ======================================================================================
# CORE STACK MANAGEMENT
# ======================================================================================

up: down ## Start all services in attached mode
	@echo -e "$(GREEN)Igniting services ... All systems GO!$(NC)"
	@$(COMPOSE) up --build -d --remove-orphans
	@echo -e "$(GREEN)Services are now running in detached mode.$(NC)"
	@$(MAKE) logs

down: ## Stop and remove all services and networks defined in the compose file
	@echo -e "$(RED)Shutting down services ... Powering down.$(NC)"
	@$(COMPOSE) down --remove-orphans

start: ## Start all stopped services
	@echo -e "$(GREEN)Starting services...$(NC)"
	@$(COMPOSE) up -d --remove-orphans

stop: ## Stop all services without removing them
	@echo -e "$(YELLOW)Stopping services...$(NC)"
	@$(COMPOSE) stop

restart: ## Restart all services
	@echo -e "$(YELLOW)Rebooting services...$(NC)"
	@$(COMPOSE) restart

# ======================================================================================
# BUILDING IMAGES
# ======================================================================================

build: ## Build images for specified service (make build service=web) or all
	@echo -e "$(BLUE)Building images...$(NC)"
	@$(COMPOSE) build $(service)

no-cache: ## Force rebuild images without cache
	@echo -e "$(YELLOW)Rebuilding without cache...$(NC)"
	@$(COMPOSE) build --no-cache $(service)

# ======================================================================================
# INFORMATION & DEBUGGING
# ======================================================================================

ps: ## List all running containers
	@$(COMPOSE) ps

logs: ## Follow logs for specified service (make logs service=core) or all
	@echo -e "$(BLUE)Tapping into log stream...$(NC)"
	@$(COMPOSE) logs -f --tail="100" $(service)

ssh: ## Shell into a container (make ssh service=core)
	@if [ -z "$(service)" ]; then \
		echo -e "$(RED)Error: Service name required. Usage: make ssh service=<service_name>$(NC)"; \
		exit 1; \
	fi
	@echo -e "$(GREEN)Connecting to $(service)...$(NC)"
	@$(COMPOSE) exec $(service) /bin/sh || $(COMPOSE) exec $(service) /bin/bash

it: ssh ## Alias for ssh

# ======================================================================================
# SECRETS MANAGEMENT (SOPS)
# ======================================================================================
encrypt: ## Encrypt local .env files to secrets/
	@echo -e "$(BLUE)Encrypting ...$(NC)"

	@echo -e "$(GREEN)Encryption complete.$(NC)"

decrypt: ## Decrypt secrets/ files to local .env locations
	@echo -e "$(BLUE)Decrypting ...$(NC)"

	@echo -e "$(GREEN)Decryption complete.$(NC)"

update-keys: ## Update SOPS encryption keys (rotate) for files in secrets/
	@echo -e "$(BLUE)Updating keys ...$(NC)"

	@echo -e "$(GREEN)Keys updated.$(NC)"

# ======================================================================================
# COMMIT MANAGEMENT
# ======================================================================================

commit: encrypt ## Stage all changes and commit using the safe commit script


safe-commit: commit ## Alias for commit

# ======================================================================================

.PHONY: help all clean fclean re up down start restart stop logs build no-cache list inspect ssh exec migrate-show migrate-generate migrate-run migrate-revert encrypt decrypt update-keys commit safe-commit
