<p align="center"><a href="https://github.com/crazy-max/docker-syspass" target="_blank"><img height="128"src="https://raw.githubusercontent.com/crazy-max/docker-syspass/master/.res/docker-syspass.jpg"></a></p>

<p align="center">
  <a href="https://microbadger.com/images/crazymax/syspass"><img src="https://images.microbadger.com/badges/version/crazymax/syspass.svg?style=flat-square" alt="Version"></a>
  <a href="https://travis-ci.com/crazy-max/docker-syspass"><img src="https://img.shields.io/travis/com/crazy-max/docker-syspass/master.svg?style=flat-square" alt="Build Status"></a>
  <a href="https://hub.docker.com/r/crazymax/syspass/"><img src="https://img.shields.io/docker/stars/crazymax/syspass.svg?style=flat-square" alt="Docker Stars"></a>
  <a href="https://hub.docker.com/r/crazymax/syspass/"><img src="https://img.shields.io/docker/pulls/crazymax/syspass.svg?style=flat-square" alt="Docker Pulls"></a>
  <a href="https://quay.io/repository/crazymax/syspass"><img src="https://quay.io/repository/crazymax/syspass/status?style=flat-square" alt="Docker Repository on Quay"></a>
  <a href="https://www.codacy.com/app/crazy-max/docker-syspass"><img src="https://img.shields.io/codacy/grade/583373a748d24c868a4809caace825bd.svg?style=flat-square" alt="Code Quality"></a>
  <a href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=CPB3K38DL665W"><img src="https://img.shields.io/badge/donate-paypal-7057ff.svg?style=flat-square" alt="Donate Paypal"></a>
</p>

## About

🐳 [sysPass](https://syspass.org) Docker image based on Alpine Linux and Nginx.<br />
If you are interested, [check out](https://hub.docker.com/r/crazymax/) my other 🐳 Docker images!

## Features

### Included

* Alpine Linux 3.8, Nginx, PHP 7.2
* OPCache enabled to store precompiled script bytecode in shared memory
* Configuration and backups stored in a dedicated folder

### From docker-compose

* [Traefik](https://github.com/containous/traefik-library-image) as reverse proxy and creation/renewal of Let's Encrypt certificates
* [MariaDB](https://github.com/docker-library/mariadb) image as database instance

## Docker

### Environment variables

* `TZ` : The timezone assigned to the container (default `UTC`)
* `PUID` : sysPass user id (default `1000`)
* `PGID`: sysPass group id (default `1000`)
* `MEMORY_LIMIT` : PHP memory limit (default `256M`)
* `UPLOAD_MAX_SIZE` : Upload max size (default `16M`)
* `OPCACHE_MEM_SIZE` : PHP OpCache memory consumption (default `128`)

### Volumes

* `/data` : Contains configuration, cache and backups

### Ports

* `80` : HTTP port

## Use this image

### Docker Compose

Docker compose is the recommended way to run this image. Copy the content of folder [examples/compose](examples/compose) in `/var/syspass/` on your host for example. Edit the compose and env files with your preferences and run the following commands :

```bash
touch acme.json
chmod 600 acme.json
docker-compose up -d
docker-compose logs -f
```

### Command line

You can also use the following commands :

```bash
docker run -d --name syspass-db \
  -e "MYSQL_ALLOW_EMPTY_PASSWORD=yes" \
  -e "MYSQL_DATABASE=syspass" \
  -e "MYSQL_USER=syspass" \
  -e "MYSQL_PASSWORD=syspass" \
  mariadb:10.2
```

```bash
docker run -d -p 80:80 --name syspass \
  --link syspass-db \
  -v $(pwd)/data:/data \
  crazymax/syspass:latest
```

> Use `syspass-db` as database host in the installation wizard with this example

## Notes

### Installation wizard

You have to check [Hosting Mode](https://doc.syspass.org/en/installing/hostingmode.html) in the installation wizard to skip database and user creation if you use MariaDB's Docker image.

## How can I help ?

All kinds of contributions are welcome :raised_hands:!<br />
The most basic way to show your support is to star :star2: the project, or to raise issues :speech_balloon:<br />
But we're not gonna lie to each other, I'd rather you buy me a beer or two :beers:!

[![Paypal](.res/paypal.png)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=CPB3K38DL665W)

## License

MIT. See `LICENSE` for more details.
