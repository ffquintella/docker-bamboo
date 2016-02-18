# Table of Contents


## Supported tags

Current branch:

*  `3.10.1`, `latest`

For previous versions or newest releases see other branches.

## Introduction


Dockerfiles to build [Bamboo](https://www.atlassian.com/software/bamboo/)


### Version

* Version: `3.10.1`


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



### Entrypoint

You can execute Splunk commands by using

```
docker exec splunk entrypoint.sh splunk version
```

*Splunk is launched in background. Which means that when Splunk restarts (after some configuration changes) - the container will not be affected.*

### Hostname

It is recommended to specify `hostname` for this image, so if you will recreate Splunk instance you will keep the same hostname.

### Basic configuration using Environment Variables

> Some basic configurations are allowed to configure the system and make it easier to change at docker command line

- `SPLUNK_ENABLE_DEPLOY_SERVER='true'` - enable deployment server on Indexer.
    - Available: *splunk* image only.


## Upgrade from previous version

Upgrade example below

```
TBD
```
