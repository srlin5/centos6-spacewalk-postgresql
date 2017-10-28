#
# Dockerfile - Spacewalk
#
# - Build
# hg clone https://bitbucket.org/bashell-com/spacewalk /opt/docker-spacewalk
# docker build --rm -t spacewalk /opt/docker-spacewalk
#
# - Run
# docker run --privileged=true -d --name="spacewalk" -h "spackewalk" spacewalk
# - Run your own
# hg clone https://bitbucket.org/bashell-com/spacewalk /opt/docker-spacewalk
# docker build --rm -t spacewalk /opt/docker-spacewalk
# docker run --privileged=true -d --name="spacewalk" spacewalk


# 1. Base images
FROM     centos:6
MAINTAINER Theo Lew <theo@opsmen.nl>

# 2. Set the environment variable
WORKDIR /opt
ENV VERSION=2.6-0

# 3. Add the epel, spacewalk, jpackage repository, supervisord
# No ; yum upgrade -y
ADD conf/jpackage.repo /etc/yum.repos.d/jpackage.repo
RUN yum install -y epel-release 
RUN yum install -y http://spacewalk.redhat.com/yum/latest/RHEL/6/x86_64/spacewalk-repo-$VERSION.el6.noarch.rpm  
# RUN yum check-update 
RUN yum update -y  
RUN yum install -y spacewalk-setup-postgresql spacewalk-postgresql tomcat-native python-setuptools pip easy_install
RUN yum clean all 
# RUN easy_install pip 
# RUN pip install supervisor 
# RUN pip install --upgrade meld3==0.6.10 
# RUN mkdir /etc/supervisord.d && rm -rf /root/.cache

# 4. Install supervisord config
# ADD conf/supervisord.conf /etc/supervisord.d/supervisord.conf

# 5. Install spacewalk initial and running scripts

ADD conf/answer.txt   /opt/answer.txt
ADD conf/spacewalk.sh /opt/spacewalk.sh

# 6. Start supervisord
# CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.d/supervisord.conf"]

# System Log
VOLUME /var/log

# PostgreSQL Data
VOLUME /var/lib/pgsql/data

# RPM repository
VOLUME /var/satellite

# Bootstrap directory
VOLUME /var/www/html/pub

# Open Ports
EXPOSE 80 443 5222 5432 5269


# Set date and timezone

RUN cat /etc/sysconfig/clock > /dev/null && echo ZONE="Europe/Amsterdam" > /etc/sysconfig/clock && cp /etc/localtime /root/old.timezone && rm /etc/localtime && ln -s /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime
                  

# Set hostname
USER root
RUN sudo hostname -v spwsrv01.srt.io

