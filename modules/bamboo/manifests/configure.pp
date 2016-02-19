class bamboo::configure (
  $version            = $bamboo::params::version,
  $appdir             = $bamboo::params::real_appdir,
  $homedir            = $bamboo::params::homedir,
  $user               = $bamboo::params::user,
  $group              = $bamboo::params::group,
  $java_home          = $bamboo::params::java_home,
  $jvm_xmx            = $bamboo::params::jvm_xmx,
  $jvm_xms            = $bamboo::params::jvm_xms,
  $jvm_permgen        = $bamboo::params::jvm_permgen,
  $jvm_opts           = $bamboo::params::jvm_opts,
  $jvm_optional       = $bamboo::params::jvm_optional,
  $context_path       = $bamboo::params::context_path,
  $tomcat_port        = $bamboo::params::tomcat_port,
  $max_threads        = $bamboo::params::max_threads,
  $min_spare_threads  = $bamboo::params::min_spare_threads,
  $connection_timeout = $bamboo::params::connection_timeout,
  $proxy              = $bamboo::params::proxy,
  $accept_count       = $bamboo::params::accept_count,
) {



  file { "${appdir}/bin/setenv.sh":
    ensure  => 'file',
    owner   => $user,
    group   => $group,
    mode    => '0755',
    content => template('bamboo/setenv.sh.erb'),
  }

  file { "${appdir}/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties":
    ensure  => 'file',
    owner   => $user,
    group   => $group,
    content => "bamboo.home=${homedir}",
  }

  $changes = [
    "set Server/Service[#attribute/name='Catalina']/Engine/Host/Context/#attribute/path '${context_path}'",
    "set Server/Service/Connector/#attribute/maxThreads '${max_threads}'",
    "set Server/Service/Connector/#attribute/minSpareThreads '${min_spare_threads}'",
    "set Server/Service/Connector/#attribute/connectionTimeout '${connection_timeout}'",
    "set Server/Service/Connector/#attribute/port '${tomcat_port}'",
    "set Server/Service/Connector/#attribute/acceptCount '${accept_count}'",
  ]

  if !empty($proxy) {
    $_proxy   = suffix(prefix(join_keys_to_values($proxy, " '"), 'set Server/Service/Connector/#attribute/'), "'")
    $_changes = concat($changes, $_proxy)
  }
  else {
    $_proxy   = undef
    $_changes = $changes
  }

  augeas { "${appdir}/conf/server.xml":
    lens    => 'Xml.lns',
    incl    => "${appdir}/conf/server.xml",
    changes => $_changes,
  }

}
