# Class: bamboo
#
# This module manages Atlassian Bamboo
#
# Refer to the README at the root of this module for documentation
#
class bamboo (
  $version            = $bamboo::params::version,
  $extension          = $bamboo::params::extension,
  $manage_installdir  = $bamboo::params::manage_installdir,
  $installdir         = $bamboo::params::installdir,
  $manage_appdir      = $bamboo::params::manage_appdir,
  $appdir             = $bamboo::params::appdir,
  $homedir            = $bamboo::params::homedir,
  $context_path       = $bamboo::params::context_path,
  $tomcat_port        = $bamboo::params::tomcat_port,
  $max_threads        = $bamboo::params::max_threads,
  $min_spare_threads  = $bamboo::params::min_spare_threads,
  $connection_timeout = $bamboo::params::connection_timeout,
  $accept_count       = $bamboo::params::accept_count,
  $proxy              = $bamboo::params::proxy,
  $manage_user        = $bamboo::params::manage_user,
  $manage_group       = $bamboo::params::manage_group,
  $user               = $bamboo::params::user,
  $group              = $bamboo::params::group,
  $uid                = $bamboo::params::uid,
  $gid                = $bamboo::params::gid,
  $password           = $bamboo::params::password,
  $shell              = $bamboo::params::shell,
  $java_home          = $bamboo::params::java_home,
  $jvm_xms            = $bamboo::params::jvm_xms,
  $jvm_xmx            = $bamboo::params::jvm_xmx,
  $jvm_permgen        = $bamboo::params::jvm_permgen,
  $jvm_opts           = $bamboo::params::jvm_opts,
  $jvm_optional       = $bamboo::params::jvm_optional,
  $download_url       = $bamboo::params::download_url,
  $manage_service     = $bamboo::params::manage_service,
  $service_ensure     = $bamboo::params::service_ensure,
  $service_enable     = $bamboo::params::service_enable,
  $service_file       = $bamboo::params::service_file,
  $service_template   = $bamboo::params::service_template,
  $shutdown_wait      = $bamboo::params::shutdown_wait,
  $install            = $bamboo::params::install
) inherits bamboo::params {


  validate_re($extension, '^(tar\.gz|\.zip)$')
  validate_absolute_path($installdir)
  validate_absolute_path($homedir)

  if !empty($context_path) { validate_string($context_path) }

  validate_integer($tomcat_port)
  validate_integer($max_threads)
  validate_integer($min_spare_threads)
  validate_integer($connection_timeout)
  validate_integer($accept_count)
  validate_hash($proxy)
  validate_bool($manage_user)
  validate_bool($manage_group)

  validate_re($user, '^[a-z_][a-z0-9_-]*[$]?$')
  validate_re($group, '^[a-z_][a-z0-9_-]*[$]?$')

  if $uid { validate_integer($uid) }
  if $gid { validate_integer($gid) }

  validate_string($password)
  validate_absolute_path($shell)
  validate_absolute_path($java_home)
  validate_re($jvm_xms, '\d+(m|g)$')
  validate_re($jvm_xmx, '\d+(m|g)$')
  validate_re($jvm_permgen, '\d+(m|g)$')

  if !empty($jvm_opts) { validate_string($jvm_opts) }
  if !empty($jvm_optional) { validate_string($jvm_optional) }

  validate_re($download_url, '^((https?|ftps?):\/\/)?([\da-z\.-]+)\.?([a-z\.]{2,6})([\/\w \.-]*)*\/?$')
  validate_bool($manage_service)
  validate_re($service_ensure, '(running|stopped)')
  validate_bool($service_enable)
  validate_absolute_path($service_file)

  validate_re($service_template, '^(\w+)\/([\/\.\w\s]+)$',
    'service_template should be modulename/path/to/template.erb'
  )

  validate_integer($shutdown_wait)

  if $appdir == undef or $appdir == '' {
    $real_appdir = "${installdir}/atlassian-bamboo-${version}"
  }
  else {
    validate_absolute_path($appdir)
    $real_appdir = $appdir
  }

  anchor { 'bamboo::start': } ->
  class { 'bamboo::install': } ->
  class { 'bamboo::configure':
    version            => $version,
    appdir             => $real_appdir,
    homedir            => $homedir,
    user               => $user,
    group              => $group,
    java_home          => $java_home,
    jvm_xmx            => $jvm_xmx,
    jvm_xms            => $jvm_xms,
    jvm_permgen        => $jvm_permgen,
    jvm_opts           => $jvm_opts,
    jvm_optional       => $jvm_optional,
    context_path       => $context_path,
    tomcat_port        => $tomcat_port,
    max_threads        => $max_threads,
    min_spare_threads  => $min_spare_threads,
    connection_timeout => $connection_timeout,
    proxy              => $proxy,
    accept_count       => $accept_count

  } ~>
  class { 'bamboo::service': } ->
  anchor { 'bamboo::end': }

}
