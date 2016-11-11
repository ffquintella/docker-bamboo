# Table of Contents


## Supported tags

Current branch:

* '5.14.1.1', 'latest'
* '5.12.1'
* `5.10.1`, `5.10.3`, `5.12.1`

For previous versions or newest releases see other branches.

## Introduction


Dockerfiles to build [Bamboo](https://www.atlassian.com/software/bamboo/)


### Version

* `5.14.1.1` - Latest: Upgrade to Bamboo 5.14.1
* `5.12.1`
* `5.10.3`
* `5.10.1`


## Installation

Pull the image from docker hub.

```bash
docker pull ffquintella/docker-bamboo
```

Alternately you can build the image locally.

```bash
git clone https://github.com/ffquintella/docker-bamboo.git
cd docker-bamboo
./build.sh
```

## Quick Start

Not written yet


## Configuration

### Data Store

This image doesn't use data volumes by default but you should configure /opt/bamboo-home to point to a data volume or to point to a folder in the local disk


### User

No special users

### Ports

Next ports are exposed

* `8085/tcp` - Bamboo default web interface
* `54663/tcp` - Bamboo broker


### Entrypoint

We use puppet as the default entry point to manage the environment

*Bamboo is launched in background. Which means that is possible to restart bamboo without restarting the container.*

### Hostname

It is recommended to specify `hostname` for this image, so if you will recreate bamboo instance you will keep the same hostname.

### Basic configuration using Environment Variables

> Some basic configurations are allowed to configure the system and make it easier to change at docker command line

- FACTER_BAMBOO_VERSION "5.10.1.1" - Bamboo version to be installed
- FACTER_BAMBOO_INSTALLDIR "/opt/bamboo" - Bamboo install dir
- FACTER_BAMBOO_HOME "/opt/bamboo-home" - Bamboo home
- FACTER_BAMBOO_DOWNLOAD_URL "https://www.atlassian.com/software/bamboo" - Url used to download bamboo in container creation
- JAVA_HOME "/opt/java_home" - Java home (we use oracle jdk 1.8.11)
- FACTER_BAMBOO_PROXY "false" - If bamboo is behind a proxy
- FACTER_BAMBOO_PROXY_SCHEME "https"
- FACTER_BAMBOO_PROXY_NAME "bamboo.local"
- FACTER_BAMBOO_PROXY_PORT "443"
- FACTER_JAVA_HOME $JAVA_HOME - Just to be acessible in puppet
- FACTER_PRE_RUN_CMD "" - Command to be executed just before starting bamboo
- FACTER_EXTRA_PACKS "" - Packages to be installed at runtime (must be centos7 packages on the defaul repos or epel)


## Upgrade from previous version

Basically stop your running container;

Docker pull latest version

Start a new instance with the new image (backup your data dir)

## Credits

My thanks to the following

- Every one who worked building docker
- Github for the dvcs support
- Puppet guys for the great tool
- Josh Beard for the [great puppet module](https://forge.puppetlabs.com/joshbeard/bamboo) witch made this image so easier to create
