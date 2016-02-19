
class { 'bamboo::params': }


$real_appdir = "${bamboo_installdir}/atlassian-bamboo-${bamboo_version}"

if $bamboo_proxy  != 'false' {
  class { 'bamboo::configure':
    version      => $bamboo_version,
    appdir       => $real_appdir,
    homedir      => $bamboo_home,
    java_home    => $java_home,
    context_path => $bamboo_context,
    proxy        => {
      scheme    => $bamboo_proxy_scheme,
      proxyName => $bamboo_proxy_name,
      proxyPort => $bamboo_proxy_port,
    },
  }
} else {
  class { 'bamboo::configure':
    version      => $bamboo_version,
    appdir       => $real_appdir,
    homedir      => $bamboo_home,
    java_home    => $java_home,
    context_path => $bamboo_context,
  }
}
# Cleaning unused packages to decrease image size
exec {'Starting Bamboo':
  path  => '/bin:/sbin:/usr/bin:/usr/sbin',
  command => "echo \"Starting Docker ...\"; $bamboo_installdir/atlassian-bamboo-$bamboo_version/bin/start-bamboo.sh; "
}
