*This file must explain, in clear and simple terms, how an end user or administrator can:*
- Understand what services are provided by the stack.
- Start and stop the project.
- Access the website and the administration panel.
- Locate and manage credentials.
- Check that the services are running correctly.

# User documentation

## What this stack provides

A self-hosted WordPress website served over HTTPS. Three services run
behind the scenes:

| Service   | Role                                  | Reachable from host? |
|-----------|---------------------------------------|----------------------|
| nginx     | Web server, TLS termination           | Yes, port 443        |
| wordpress | WordPress + PHP-FPM                   | No (internal only)   |
| mariadb   | Database                              | No (internal only)   |

## Starting and stopping

From the project root:

- Start everything (build first time):  `make`
- Stop without removing containers:    `make stop`
- Start again after `stop`:             `make start`
- Stop and remove containers/network:  `make down`
- Full wipe (containers, images, data): `make fclean`

## Accessing the website

Add this line to your `/etc/hosts` once:
127.0.0.1 sbruma.42.fr

Then open:

- Public site:  `https://sbruma.42.fr`
- Admin panel: `https://sbruma.42.fr/wp-admin`

The TLS certificate is self-signed, so your browser will show a warning the first time. That is expected — accept it to continue.

## Credentials

All credentials live in `srcs/.env` on the host machine. This file is **not** committed to git. It contains:

- `MYSQL_ROOT_PASSWORD`, `MYSQL_USER`, `MYSQL_PASSWORD` — database access.
- `WORDPRESS_ADMIN_USER`, `WORDPRESS_ADMIN_PASSWORD` — the WordPress admin login.
- `WORDPRESS_USER`, `WORDPRESS_PASSWORD` — a second, non-admin user (author role).

To change a password after the stack is running, log in to the WordPress admin panel and use the user-management UI. Changing values in `.env` afterwards has no effect, because credentials are written into the database on the very first run.

## Checking that services are running

- List containers and state: `make ps`
- Stream live logs:           `make logs`
- Inspect a single service:   `docker logs nginx` (or `wordpress`, `mariadb`)
- Test from the host:         `curl -k https://sbruma.42.fr`

A healthy stack shows three containers in state `running` (or `Up`), the website responds with the WordPress home page, and the admin panel accepts the admin credentials.