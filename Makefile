# Docker Services:
#   up - Start services (use: make up [service...] or make up MODE=prod, ARGS="--build" for options)
#   down - Stop services (use: make down [service...] or make down MODE=prod, ARGS="--volumes" for options)
#   build - Build containers (use: make build [service...] or make build MODE=prod)
#   logs - View logs (use: make logs [service] or make logs SERVICE=backend, MODE=prod for production)
#   restart - Restart services (use: make restart [service...] or make restart MODE=prod)
#   shell - Open shell in container (use: make shell [service] or make shell SERVICE=gateway, MODE=prod, default: backend)
#   ps - Show running containers (use MODE=prod for production)
#
# Convenience Aliases (Development):
#   dev-up - Alias: Start development environment
#   dev-down - Alias: Stop development environment
#   dev-build - Alias: Build development containers
#   dev-logs - Alias: View development logs
#   dev-restart - Alias: Restart development services
#   dev-shell - Alias: Open shell in backend container
#   dev-ps - Alias: Show running development containers
#   backend-shell - Alias: Open shell in backend container
#   gateway-shell - Alias: Open shell in gateway container
#   mongo-shell - Open MongoDB shell
#
# Convenience Aliases (Production):
#   prod-up - Alias: Start production environment
#   prod-down - Alias: Stop production environment
#   prod-build - Alias: Build production containers
#   prod-logs - Alias: View production logs
#   prod-restart - Alias: Restart production services
#
# Backend:
#   backend-build - Build backend TypeScript
#   backend-install - Install backend dependencies
#   backend-type-check - Type check backend code
#   backend-dev - Run backend in development mode (local, not Docker)
#
# Database:
#   db-reset - Reset MongoDB database (WARNING: deletes all data)
#   db-backup - Backup MongoDB database
#
# Cleanup:
#   clean - Remove containers and networks (both dev and prod)
#   clean-all - Remove containers, networks, volumes, and images
#   clean-volumes - Remove all volumes
#
# Utilities:
#   status - Alias for ps
#   health - Check service health
#
# Help:
#   help - Display this help message

# Variables
MODE ?= development
COMPOSE_FILE = docker/compose.$(MODE).yaml

# Docker Services:
up:
    docker compose -f $(COMPOSE_FILE) up -d $(ARGS)

down:
    docker compose -f $(COMPOSE_FILE) down $(ARGS)

build:
    docker compose -f $(COMPOSE_FILE) build $(ARGS)

logs:
    docker compose -f $(COMPOSE_FILE) logs -f $(SERVICE)

restart:
    docker compose -f $(COMPOSE_FILE) restart $(SERVICE)

shell:
    docker compose -f $(COMPOSE_FILE) exec $(or $(SERVICE), backend) sh

ps:
    docker compose -f $(COMPOSE_FILE) ps

# Convenience Aliases (Development):
dev-up:
    make up MODE=development

dev-down:
    make down MODE=development

dev-build:
    make build MODE=development

dev-logs:
    make logs MODE=development

dev-restart:
    make restart MODE=development

dev-shell:
    make shell MODE=development SERVICE=backend

dev-ps:
    make ps MODE=development

backend-shell:
    make shell SERVICE=backend

gateway-shell:
    make shell SERVICE=gateway

mongo-shell:
    docker compose -f $(COMPOSE_FILE) exec mongo mongosh -u $$MONGO_INITDB_ROOT_USERNAME -p $$MONGO_INITDB_ROOT_PASSWORD

# Convenience Aliases (Production):
prod-up:
    make up MODE=production

prod-down:
    make down MODE=production

prod-build:
    make build MODE=production

prod-logs:
    make logs MODE=production

prod-restart:
    make restart MODE=production

# Backend:
backend-build:
    cd backend && npm run build

backend-install:
    cd backend && npm install

backend-type-check:
    cd backend && npm run type-check

backend-dev:
    cd backend && npm run dev

# Database:
db-reset:
    @echo "WARNING: This will delete all data in the database. Are you sure? [y/N]"
    @read -r ans && [ "$$ans" = "y" ] || exit 1
    docker compose -f $(COMPOSE_FILE) down -v

db-backup:
    @echo "Creating backup..."
    docker compose -f $(COMPOSE_FILE) exec mongo mongodump --out /data/db/backup

# Cleanup:
clean:
    docker compose -f docker/compose.development.yaml down
    docker compose -f docker/compose.production.yaml down

clean-all:
    docker compose -f docker/compose.development.yaml down -v --rmi all --remove-orphans
    docker compose -f docker/compose.production.yaml down -v --rmi all --remove-orphans

clean-volumes:
    docker volume prune -f

# Utilities:
status: ps

health:
    @echo "Checking Gateway Health..."
    @curl -s http://localhost:5921/health || echo "Gateway is down"
    @echo "\nChecking Backend Health via Gateway..."
    @curl -s http://localhost:5921/api/health || echo "Backend is down"

# Help:
help:
    @echo "Available commands:"
    @echo "  make up [MODE=prod]       - Start services"
    @echo "  make down [MODE=prod]     - Stop services"
    @echo "  make build [MODE=prod]    - Build services"
    @echo "  make logs [SERVICE=name]  - View service logs"
    @echo "  make shell [SERVICE=name] - Open shell in container"
    @echo "  make dev-up               - Start development environment"
    @echo "  make prod-up              - Start production environment"
    @echo "  make health               - Check service health"

.PHONY: up down build logs restart shell ps dev-up dev-down dev-build dev-logs dev-restart dev-shell dev-ps backend-shell gateway-shell mongo-shell prod-up prod-down prod-build prod-logs prod-restart backend-build backend-install backend-type-check backend-dev db-reset db-backup clean clean-all clean-volumes status health help