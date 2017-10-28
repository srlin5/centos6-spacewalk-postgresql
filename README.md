# Spacewalk #
This image provides all-in-one [Spacewalk][1] along with its embedded PostgreSQL database and also the Apache web server.

# Build
docker build . -t centos6-spacewalk-postgresql:latest

# Run with
docker run -ti <build container ID> /bin/bash

## Supported tags and respective Dockerfile links ##
- `latest` ([Dockerfile][2])

## Usage ##
`Note` *This image is required to run with **privileged** mode.*

### Using the embedded Apache web server ###
```
# docker run --privileged=true -d --name="centos6-spacewalk-postgresql" -p 80:80 -p 443:443 centos6-spacewalk-postgresql
```
`Note` *The self-signed SSL certificate will be generated at the first time you run this container.*
centos6-spacewalk-postgresql
### Run without exposing port 80 and 443 ###
```
# docker run --privileged=true -d --name="centos6-spacewalk-postgresql" centos6-spacewalk-postgresql
```
Then inspect the running container to get an IP address.
```
# docker inspect -f '{{ .NetworkSettings.IPAddress }}' spacewalk
172.17.0.126
```
Now you can use an NginX reverse proxy (with you real SSL certificate) to `172.17.0.126` port `80` and `443`.

### Build and run your own image ###
```
# hg clone https://bitbucket.org/bashell-com/spacewalk /opt/docker-spacewalk
# docker build --rm -t centos6-spacewalk-postgresql /opt/docker-spacewalk
# docker run --privileged=true -d --name="spacewalk" centos6-spacewalk-postgresql
```

## Customizing ##
- Self-signed SSL certificate will be generated from [/opt/answer.txt][3], which can be override using `-v` option.
  - `docker run --privileged=true -d --name="spacewalk" -v /path-to-your/answer.txt:/opt/answer.txt bashell/spacewalk`
- Volumes below will be created, which you may want to manage them separately from the container life cycle.
  - `/var/log` System log
  - `/var/lib/pgsql/data` PostgreSQL data
  - `/var/satellite` RPM repository
  - `/var/www/html/pub` Bootstrap directory

## Ports exposed and their function

The following inbound TCP ports should be open on the Spacewalk server:

    69: TFTP (PXE provisioning)
    80: Spacewalk web interface
    443: Spacewalk web interface (SSL)
    4545: Spacewalk monitoring
    5222: If you plan to push actions to client systems
    5269: If you push actions to a Spacewalk Proxy Server
    9055: Oracle XE web access

[1]: http://spacewalk.redhat.com/
[2]: https://bitbucket.org/bashell-com/spacewalk/src/default/Dockerfile?fileviewer=file-view-default
[3]: https://bitbucket.org/bashell-com/spacewalk/src/default/conf/answer.txt?fileviewer=file-view-default
