<p align="center"><a href="https://github.com/crazy-max/docker-syspass" target="_blank"><img height="128" src="https://raw.githubusercontent.com/crazy-max/docker-syspass/master/.res/docker-syspass.jpg"></a></p>

<p align="center">
  <a href="https://hub.docker.com/r/crazymax/syspass/"><img src="https://img.shields.io/badge/dynamic/json.svg?label=version&query=$.results[1].name&url=https://hub.docker.com/v2/repositories/crazymax/syspass/tags&style=flat-square" alt="Latest Version"></a>
  <a href="https://travis-ci.com/crazy-max/docker-syspass"><img src="https://img.shields.io/travis/com/crazy-max/docker-syspass/master.svg?style=flat-square" alt="Build Status"></a>
  <a href="https://hub.docker.com/r/crazymax/syspass/"><img src="https://img.shields.io/docker/stars/crazymax/syspass.svg?style=flat-square" alt="Docker Stars"></a>
  <a href="https://hub.docker.com/r/crazymax/syspass/"><img src="https://img.shields.io/docker/pulls/crazymax/syspass.svg?style=flat-square" alt="Docker Pulls"></a>
  <a href="https://quay.io/repository/crazymax/syspass"><img src="https://quay.io/repository/crazymax/syspass/status?style=flat-square" alt="Docker Repository on Quay"></a>
  <a href="https://www.codacy.com/app/crazy-max/docker-syspass"><img src="https://img.shields.io/codacy/grade/583373a748d24c868a4809caace825bd.svg?style=flat-square" alt="Code Quality"></a>
  <br /><a href="https://github.com/sponsors/crazy-max"><img src="https://img.shields.io/badge/sponsor-crazy--max-181717.svg?logo=github&style=flat-square" alt="Become a sponsor"></a>
  <a href="https://www.paypal.me/crazyws"><img src="https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal&style=flat-square" alt="Donate Paypal"></a>
</p>

## :warning: Abandoned project

This project is not maintained anymore and is abandoned. Feel free to fork and make your own changes if needed.

## About

🐳 [sysPass](https://syspass.org) Docker image based on Alpine Linux and Nginx.<br />
If you are interested, [check out](https://hub.docker.com/r/crazymax/) my other 🐳 Docker images!

💡 Want to be notified of new releases? Check out 🔔 [Diun (Docker Image Update Notifier)](https://github.com/crazy-max/diun) project!

## Features

* OPCache enabled to store precompiled script bytecode in shared memory
* Configuration and backups stored in a dedicated folder
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

* `8000` : HTTP port

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
docker run -d -p 8000:8000 --name syspass \
  --link syspass-db \
  -v $(pwd)/data:/data \
  crazymax/syspass:latest
```

> Use `syspass-db` as database host in the installation wizard with this example

## Notes

### Installation wizard

You have to check [Hosting Mode](https://doc.syspass.org/en/installing/hostingmode.html) in the installation wizard to skip database and user creation if you use MariaDB's Docker image.

## How can I help ?

All kinds of contributions are welcome :raised_hands:! The most basic way to show your support is to star :star2: the project, or to raise issues :speech_balloon: You can also support this project by [**becoming a sponsor on GitHub**](https://github.com/sponsors/crazy-max) :clap: or by making a [Paypal donation](https://www.paypal.me/crazyws) to ensure this journey continues indefinitely! :rocket:

Thanks again for your support, it is much appreciated! :pray:

## License

MIT. See `LICENSE` for more details.
