# Table of Contents


## Supported tags

Current branch:

*  `5.10.1`, `latest`

For previous versions or newest releases see other branches.

## Introduction


Dockerfiles to build [Bamboo](https://www.atlassian.com/software/bamboo/)


### Version

* Version: `5.10.1`


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

This image has two data volumes

* ` xxx ` - xxxx


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

- FACTER_BAMBOO_VERSION "5.10.1.1"
- FACTER_BAMBOO_INSTALLDIR "/opt/bamboo"
- FACTER_BAMBOO_HOME "/opt/bamboo-home"
- FACTER_BAMBOO_USER "bamboo"
- FACTER_BAMBOO_GROUP "bamboo"
- FACTER_BAMBOO_DOWNLOAD_URL "https://www.atlassian.com/software/bamboo"


## Upgrade from previous version

Upgrade example below

```
TBD
```

## Credits

My thanks to the following

- Every one who worked building docker
- Github for the dvcs support
- Puppet guys for the great tool
- Josh Beard for the [great puppet module](https://forge.puppetlabs.com/joshbeard/bamboo) witch made this image so easier to create
