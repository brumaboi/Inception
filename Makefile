NAME    = inception
SRC_DIR = srcs
COMPOSE = $(SRC_DIR)/docker-compose.yml
DATA    = $(HOME)/data

DC = docker compose -f $(COMPOSE) -p $(NAME)

all: setup build up

setup:
	@mkdir -p $(DATA)/mariadb
	@mkdir -p $(DATA)/wordpress

build:
	$(DC) build

up:
	$(DC) up -d

down:
	$(DC) down

stop:
	$(DC) stop

start:
	$(DC) start

ps:
	$(DC) ps

logs:
	$(DC) logs -f

clean:
	$(DC) down --rmi all --volumes --remove-orphans

fclean: clean
	@docker system prune -af --volumes
	@sudo rm -rf $(DATA)/mariadb $(DATA)/wordpress

re: fclean all

.PHONY: all setup build up down stop start ps logs clean fclean re