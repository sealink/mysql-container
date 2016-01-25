# MySql Container

This MySQL docker container is an alternative to MySQL Sandbox.

**For development environment only.**

## Features

1. Support an external volume, so that the data files are on the host.
1. Being able to use the correct UID and GID for the data files.  The container
   will use the mounted directory as a reference to adapt itself.
1. Support customised configuration in `/config`.

## Limitations

1. The UID and GID cannot conllide with the ones in the container.
1. If the data files supplied don't allow access from `localhost`, you have to
   use `docker exec` and MySQL's `GRANT` to correct it.
   E.g. `GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'password';`

## Usage

```
$ ls path-to-the-data-files
auto.cnf
ib_logfile0
...
mysql
performance_schema
...
$ cp -v path-to-the-data-files data
$ cp -v docker-compose.yml{.example,}
$ docker-compose up -d
$ mysql -hdocker-daemon-ip-goes-here -uroot -p
Start using MySQL...
```
