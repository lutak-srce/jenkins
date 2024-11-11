#
# = Class: jenkins
#
# This module manages jenkins
#
class jenkins (
  $package_ensure = $jenkins::params::package_ensure,
  $java_vendor    = $jenkins::params::java_vendor,
  $java_version   = $jenkins::params::java_version,
  $java_options   = '-Djava.awt.headless=true',
  $args           = '',
) inherits jenkins::params {

  require ::yum::repo::jenkins
  require "java::${java_vendor}${java_version}"

  package { 'jenkins':
    ensure  => $package_ensure,
    require => [
      Package["java-1.${java_version}.0-${java_vendor}-devel"],
      File['/etc/yum.repos.d/jenkins.repo'],
    ],
  }

  file { '/etc/sysconfig/jenkins':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0600',
    content => template('jenkins/sysconfig.erb'),
    require => Package['jenkins'],
  }

  service { 'jenkins':
    ensure  => running,
    enable  => true,
    require => Package['jenkins'],
  }
}
