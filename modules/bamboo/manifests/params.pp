class bamboo::params {
  $version            = '5.9.7'
  $extension          = 'tar.gz'
  $manage_installdir  = true
  $installdir         = '/usr/local/bamboo'
  $manage_appdir      = true
  $appdir             = undef
  $homedir            = '/var/local/bamboo'
  $context_path       = ''
  $tomcat_port        = '8085'
  $max_threads        = '150'
  $min_spare_threads  = '25'
  $connection_timeout = '20000'
  $accept_count       = '100'
  $proxy              = {}
  $manage_user        = true
  $manage_group       = true
  $user               = 'bamboo'
  $group              = 'bamboo'
  $uid                = undef
  $gid                = undef
  $password           = '*'
  $shell              = '/bin/bash'
  $java_home          = '/usr/lib/jvm/java'
  $jvm_xms            = '256m'
  $jvm_xmx            = '1024m'
  $jvm_permgen        = '256m'
  $jvm_opts           = ''
  $jvm_optional       = ''
  $download_url       = 'https://www.atlassian.com/software/bamboo/downloads/binary'
  $manage_service     = true
  $service_ensure     = 'running'
  $service_enable     = true
  $shutdown_wait      = '20'
  $install            = true

  if $appdir == undef or $appdir == '' {
    $real_appdir = "${installdir}/atlassian-bamboo-${version}"
  }

  case $::os[family] {
    'RedHat': {
      if $::os[release][major] == '7' {
        if($::virtual == 'docker'){
          $service_file     = '/etc/init.d/bamboo'
          $service_template = 'bamboo/bamboo.init.erb'
        }else{
          $service_file     = '/usr/lib/systemd/system/bamboo.service'
          $service_template = 'bamboo/bamboo.service.erb'
        }
      }
      elsif $::operatingsystemmajrelease == '6' or $::operatingsystem == 'Amazon'{
        $service_file     = '/etc/init.d/bamboo'
        $service_template = 'bamboo/bamboo.init.erb'
      }
      else {
        fail("${::osfamily} ${::operatingsystemmajrelease} not supported.")
      }
    }
    'Windows': {
      fail('bamboo module is not supported on Windows')
    }
    default: {
      $service_file     = '/etc/init.d/bamboo'
      $service_template = 'bamboo/bamboo.init.erb'
    }
  }

}
