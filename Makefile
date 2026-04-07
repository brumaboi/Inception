SRC_DIR = srcs
COMPOSE_FILE = $(SRC_DIR)/docker-compose.yml

DC = docker-compose -f $(COMPOSE_FILE)

all: build up

build:
	$(DC) build

up: build
	$(DC) up -d

down:
	$(DC) down

clean:
	$(DC) down --rmi all --volumes --remove-orphans

re: down up

.PHONY: all build up down clean re