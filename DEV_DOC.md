# Developer documentation

## Prerequisites

- A Linux virtual machine (the subject mandates running on a VM).
- Docker Engine and Docker Compose v2 (`docker compose` command).
- `make`, `git`, `sudo`.
- The user that runs `make` must be in the `docker` group.

## Initial setup from scratch

1. Clone the repository on the VM.
2. Add `127.0.0.1 sbruma.42.fr` to `/etc/hosts`.
3. Create the host data directories (the Makefile does this for you, but you can do it manually): mkdir -p ~/data/mariadb ~/data/wordpress
4. Create `srcs/.env` (it is gitignored, so it is not in the repo). Use the template in the README and replace every `ChangeMe_*` value with a strong password. The admin username **must not** contain `admin`/`Admin`/`administrator`/`Administrator`.

## Build and launch

From the project root:
- make          # build images then start containers in the background
- make build    # only build
- make up       # only start (assumes images are built)
- make re       # full rebuild (fclean + all)

The Makefile runs `docker compose -f srcs/docker-compose.yml -p inception` under the hood. All Dockerfiles are referenced from the compose file; nothing is pulled from Docker Hub except the Alpine 3.22 base.

## Managing containers and volumes

- View running containers: `make ps`
- Stream logs:              `make logs`
- Stop:                     `make stop`  (containers remain)
- Down:                     `make down`  (containers/network removed, volumes kept)
- Clean:                    `make clean` (also removes images and named volumes)
- Full clean:               `make fclean` (also removes host data dirs and dangling Docker objects)

To enter a running container for debugging:
- docker exec -it wordpress sh
- docker exec -it mariadb   sh
- docker exec -it nginx     sh

## Where data is stored and how it persists

Two named Docker volumes are declared in `srcs/docker-compose.yml`:

| Volume      | Mounted at (in container) | Backed by (on host)        |
|-------------|---------------------------|----------------------------|
| `mariadb`   | `/var/lib/mysql`          | `~/data/mariadb`           |
| `wordpress` | `/var/www/html`           | `~/data/wordpress`         |

Both use the `local` driver with `driver_opts: { type: none, o: bind, device: ... }`. From Docker's API perspective these are named volumes (they appear in `docker volume ls`); on the host they live at `~/data/<name>` so they are easy to inspect and back up.

Because the data lives on the host, `make down` does **not** lose data.
Only `make fclean` (which calls `sudo rm -rf ~/data/...`) wipes it.

## File layout
```
├── Makefile
├── README.md
├── USER_DOC.md
├── DEV_DOC.md
└── srcs/
    ├── .env
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/{Dockerfile, tools/mariadb-entrypoint.sh}
        ├── nginx/{Dockerfile,   tools/nginx-entrypoint.sh}
        └── wordpress/{Dockerfile, tools/wordpress-entrypoint.sh}
```

Each service's image is tagged `<service>:inception` and is built locally from its own Dockerfile; the `latest` tag is never used.