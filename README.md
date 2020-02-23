![logo](https://raw.githubusercontent.com/mariadb-corporation/mariadb-community-columnstore-docker/master/MDB-HLogo_RGB.jpg)

# MariaDB ColumnStore 1.2 Community Docker Image

## Summary
MariaDB ColumnStore is a columnar storage engine that utilizes a massively parallel distributed data architecture. It was built by porting InfiniDB to MariaDB and has been released under the GPL license.

MariaDB ColumnStore is designed for big data scaling to process petabytes of data, linear scalability and exceptional performance with real-time response to analytical queries. It leverages the I/O benefits of columnar storage, compression, just-in-time projection, and horizontal and vertical partitioning to deliver tremendous performance when analyzing large data sets.

This project features a combined [UM/PM](https://mariadb.com/kb/en/library/columnstore-architectural-overview/) system with [monit](https://linux.die.net/man/1/monit) supervision, [tini](https://github.com/krallin/tini) `init` for containers, persistent storage and graceful startup/shutdown. This leaves ColumnStore in the proper state when a container is stopped and allows for easy restart.

## Quick Reference

* Detailed Documentation: [MariaDB Knowledge Base](https://mariadb.com/kb/en/library/mariadb-columnstore/)
* Public Forum: [Google Groups](https://groups.google.com/forum/#!forum/mariadb-columnstore)
* Jira System: [MCOL](https://jira.mariadb.org/projects/MCOL/issues)
* Sample: [Data Sets](https://github.com/mariadb-corporation/mariadb-columnstore-samples)

## Prerequisites

* [docker](https://www.docker.com/products/docker-desktop)
* [git](https://git-scm.com/downloads)

## Run Single Instance Container

### Option 1: Getting Started Using Docker Hub
```
$ docker pull mariadb/columnstore
$ docker run -d -p 3306:3306 --name mcs_container mariadb/columnstore
$ docker exec -it mcs_container bash
```

### Option 2: Getting Started Using Github
```
$ git clone https://github.com/selfieebritto/debian9docker.git
$ cd debian9docker-master
$ docker build . --tag mcs_image
$ docker run -d -p 3306:3306 --name mcs_container mcs_image
$ docker exec -it mcs_container bash
```

### Customization

The following environment variables can be used to configure behavior:
* MARIADB_ROOT_HOST : Host for root user
* MARIADB_ROOT_PASSWORD : Specify the password for the root user

Example:

```
docker run -d -p 3306:3306 \
-e MARIADB_ROOT_HOST=% \
-e MARIADB_ROOT_PASSWORD=mypassword \
--name mcs_container mcs_image
```

## Usage

*Note: Once you run your docker container, ColumnStore processes may take a couple of minutes to start up.
An additional database user named '__cej__' has been created. Removal of this user will break the [cross engine join](https://mariadb.com/kb/en/configuring-columnstore-cross-engine-joins/) function of ColumnStore.*

#### For information about ColumnStore health:
```
[root@dockerid /]# mcsadmin getSystemInfo
```
#### To access MariaDB client:
```
[root@dockerid /]# mariadb
```

```
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 13
Server version: 10.3.16-MariaDB-log Columnstore 1.2.5-1

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]>
```
