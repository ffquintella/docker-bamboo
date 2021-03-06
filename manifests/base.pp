package {'sudo':
  ensure => present
}
package{'zip':
  ensure => present
}
package{'dos2unix':
  ensure => present
}

file {'/etc/yum.repos.d/puppetlabs-pc1.repo':
  ensure => absent,
} ->

file {'/etc/yum.repos.d/epel.repo':
  ensure => present,
  content => '[epel]
name=Extra Packages for Enterprise Linux 7 - $basearch
#baseurl=http://download.fedoraproject.org/pub/epel/7/$basearch
mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-7&arch=$basearch
failovermethod=priority
enabled=1
gpgcheck=0'
}

$bamboo_dowload_url = 'https://www.atlassian.com/software/bamboo/downloads/binary'

class { 'jdk_oracle':
  version     => $java_version,
  install_dir => $java_home,
  version_update => $java_version_update,
  version_build  => $java_version_build,
  version_hash  => $java_version_hash,
  package     => 'server-jre'
} ->


file {'/opt/java_home/current':
  ensure => link,
  target => "/opt/java_home/jdk1.${java_version}.0_${java_version_update}/jre",
} ->



if $bamboo_proxy  != 'false' {
class { 'bamboo':
  version      => $bamboo_version,
  installdir   => $bamboo_installdir,
  homedir      => $bamboo_home,
  java_home    => $java_home,
  download_url => $bamboo_dowload_url,
  context_path => $bamboo_context,
  proxy        => {
    scheme    => $bamboo_proxy_scheme,
    proxyName => $bamboo_proxy_name,
    proxyPort => $bamboo_proxy_port,
  },
}
} else {
  class { 'bamboo':
    version      => $bamboo_version,
    installdir   => $bamboo_installdir,
    homedir      => $bamboo_home,
    java_home    => $java_home,
    download_url => $bamboo_dowload_url,
    context_path => $bamboo_context
  }
}

$real_appdir = "${bamboo_installdir}/atlassian-bamboo-${bamboo_version}"

exec {'Fix line endings':
  path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin',
  cwd     => "${real_appdir}/bin/",
  command => "dos2unix setenv.sh",
  require => [Class['bamboo'], Package['dos2unix']],
}

# Full update
exec {'Full update':
  path    => '/bin:/sbin:/usr/bin:/usr/sbin',
  command => 'yum -y update',
} ->
# Cleaning unused packages to decrease image size
exec {'erase installer':
  path    => '/bin:/sbin:/usr/bin:/usr/sbin',
  command => 'rm -rf /tmp/*; rm -rf /opt/staging/*',
} ->

exec {'erase cache':
  path    => '/bin:/sbin:/usr/bin:/usr/sbin',
  command => 'rm -rf /var/cache/*',
} ->
exec {'erase logs':
  path    => '/bin:/sbin:/usr/bin:/usr/sbin',
  command => 'rm -rf /var/log/*'
}

package {'openssh-server': ensure => absent }
package {'rhn-check': ensure => absent }
package {'rhn-client-tools': ensure => absent }
package {'rhn-setup': ensure => absent }
package {'rhnlib': ensure => absent }

package {'/usr/share/kde4':
  ensure => absent
}
