FROM ffquintella/docker-puppet:latest

MAINTAINER Felipe Quintella <docker-bamboo@felipe.quintella.email>

LABEL version="5.10.3"
LABEL description="This image contais the bamboo application to be used \
as a server."

#https://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo-5.10.1.1.tar.gz
#https://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo-5.10.1.tar.gz

ENV JAVA_HOME "/opt/java_home"

ENV FACTER_BAMBOO_VERSION "5.10.3"
ENV FACTER_BAMBOO_INSTALLDIR "/opt/bamboo"
ENV FACTER_BAMBOO_HOME "/opt/bamboo-home"
ENV FACTER_BAMBOO_DOWNLOAD_URL "https://www.atlassian.com/software/bamboo"
ENV FACTER_BAMBOO_CONTEXT ""
ENV FACTER_BAMBOO_PROXY "false"
ENV FACTER_BAMBOO_PROXY_SCHEME "https"
ENV FACTER_BAMBOO_PROXY_NAME "bamboo.local"
ENV FACTER_BAMBOO_PROXY_PORT "443"
ENV FACTER_JAVA_HOME $JAVA_HOME
ENV FACTER_EXTRA_PACKS ""

# Puppet stuff all the instalation is donne by puppet
# Just after it we clean up everthing so the end image isn't too big
RUN mkdir /etc/puppet; mkdir /etc/puppet/manifests ; mkdir /etc/puppet/modules
COPY manifests /etc/puppet/manifests/
COPY modules /etc/puppet/modules/
COPY start-service.sh /usr/bin/start-service
RUN chmod +x /usr/bin/start-service ; /opt/puppetlabs/puppet/bin/puppet apply -l /tmp/puppet.log  --modulepath=/etc/puppet/modules /etc/puppet/manifests/base.pp  ;\
 yum clean all ; rm -rf /tmp/* ; rm -rf /var/cache/* ; rm -rf /var/tmp/* ; rm -rf /var/opt/staging

# Ports Bamboo web interface, Bamboo broker
EXPOSE 8085/tcp 54663/tcp

WORKDIR $FACTER_BAMBOO_INSTALLDIR

# Configurations folder, install dir
VOLUME  $FACTER_BAMBOO_HOME


#CMD /opt/puppetlabs/puppet/bin/puppet apply -l /tmp/puppet.log  --modulepath=/etc/puppet/modules /etc/puppet/manifests/start.pp
CMD ["start-service"]
