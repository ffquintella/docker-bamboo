#!/bin/bash

set -e

/opt/puppetlabs/puppet/bin/puppet apply -l /tmp/puppet.log --modulepath=/etc/puppet/modules /etc/puppet/manifests/start.pp

tail -n 0 -f ${FACTER_BAMBOO_HOME}/logs/atlassian-bamboo.log &
wait
