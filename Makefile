all: up

build:
	@docker compose -f srcs/docker-compose.yml build --no-cache

up:
	@docker compose -f srcs/docker-compose.yml up -d --build

down:
	@docker compose -f srcs/docker-compose.yml down

clean:
	@docker compose -f srcs/docker-compose.yml down -v --rmi all

status:
	@docker compose -f srcs/docker-compose.yml ps

logs:
	@docker compose -f srcs/docker-compose.yml logs -f

restart: down up

fclean:
	@docker compose -f srcs/docker-compose.yml down -v --rmi all
	@docker system prune --all --volumes -f

re: fclean up

.PHONY: all build up down clean status logs restart fclean re