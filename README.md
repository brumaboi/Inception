*This project has been created as part of the 42 curriculum by sbruma*

## Description**

Inception sets up a small WordPress infrastructure inside a virtual machine using Docker Compose. Three containers are built from scratch from an Alpine 3.22 base image (the penultimate stable release):

- **NGINX** — the only public entry point, serving HTTPS on port 443 with TLSv1.2/1.3.
- **WordPress + PHP-FPM** — runs the WordPress application; not directly reachable from outside.
- **MariaDB** — stores the WordPress database; not directly reachable from outside.

All three communicate over a private Docker bridge network. Two named volumes (one for the database, one for the site files) persist data on the host under `~/data/mariadb` and `~/data/wordpress`.

### Main design choices
**◦ Virtual Machines vs Docker**
A VM emulates a full computer — its own kernel, its own boot, gigabytes of overhead. A container shares the host kernel and only isolates processes and filesystems. We use a VM as the outer host (so the project is reproducible and isolated from the real machine) and Docker inside it (so each service stays small, fast to start, and independently restartable).

**◦ Secrets vs Environment Variables**
Both pass sensitive data into a container. Environment variables are convenient but show up in `docker inspect` and the process environment. Docker secrets mount values as files at `/run/secrets/<name>`, only inside services that explicitly request them. For the mandatory part we use a `.env` file (gitignored), as allowed by the subject; the secrets approach is preferable for production.

**◦ Docker Network vs Host Network**
Host networking shares the host's network stack — every container port is a host port, with no isolation. A Docker bridge network gives the containers a private network where they reach each other by container name (`wordpress` reaches the DB at `mariadb:3306`). Only NGINX publishes a port (443) to the host.

**◦ Docker Volumes vs Bind Mounts**
Container filesystems are ephemeral. Bind mounts attach a specific host path; named volumes are managed by Docker. The subject requires named volumes *and* data under `/home/login/data`, so we declare named volumes that use the `local` driver with `o=bind` options — a Docker-managed volume backed by a known host path.

## Instructions
Build and start everything:
*make*
Other useful targets: `make down`, `make logs`, `make ps`, `make re`, `make fclean` (full wipe including the host data folders).

Open `https://sbruma.42.fr` in a browser.

## Resources
- Docker documentation: https://docs.docker.com/
- Docker Compose specification: https://docs.docker.com/compose/
- Alpine Linux package index: https://pkgs.alpinelinux.org/
- WP-CLI handbook: https://make.wordpress.org/cli/handbook/
- nginx + php-fpm: https://www.nginx.com/resources/wiki/start/topics/examples/phpfastcgionnginx/
- 42 peers' shared repositories and notes on the Inception subject.

### How AI was used
AI assistance (Claude) was used to:
- Cross-check the subject requirements against the configuration files.
- Draft the structure of this README and the user/developer docs.


Every line of the resulting code was reviewed and tested manually; no
AI-generated content is included that I cannot explain.