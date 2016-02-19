package {'sudo':
  ensure => present
}



class { 'jdk_oracle':} ->

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


# Cleaning unused packages to decrease image size
exec {'erase installer':
  path  => '/bin:/sbin:/usr/bin:/usr/sbin',
  command => 'rm -rf /tmp/*; rm -rf /opt/staging/*'
} ->

exec {'erase cache':
  path  => '/bin:/sbin:/usr/bin:/usr/sbin',
  command => 'rm -rf /var/cache/*'
} ->
exec {'erase logs':
  path  => '/bin:/sbin:/usr/bin:/usr/sbin',
  command => 'rm -rf /var/log/*'
}


package {'openssh': ensure => absent }
package {'openssh-clients': ensure => absent }
package {'openssh-server': ensure => absent }
package {'rhn-check': ensure => absent }
package {'rhn-client-tools': ensure => absent }
package {'rhn-setup': ensure => absent }
package {'rhnlib': ensure => absent }

package {'/usr/share/kde4':
  ensure => absent
}
