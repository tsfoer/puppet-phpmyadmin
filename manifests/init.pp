# == Class: phpmyadmin
#
# === Parameters
#
# [path] The path to install phpmyadmin to (default: /srv/phpmyadmin).
# [user] The user that should own that directory (default: www-data).
# [revision] The revision  (default: origin/STABLE).
# [servers] An array of servers (default: []).
#
# === Examples
#
#  class { 'phpmyadmin':
#    path     => "/srv/phpmyadmin",
#    user     => "www-data",
#    revision => "origin/RELEASE_4_0_9",
#    servers  => [
#      {
#        desc => "local",
#        host => "127.0.0.1",
#      },
#      {
#        desc => "other",
#        host => "192.168.1.30",
#      }
#    ]
#  }
#
# === Authors
#
# Arthur Leonard Andersen <leoc.git@gmail.com>
#
# === Copyright
#
# See LICENSE file, Arthur Leonard Andersen (c) 2013
# (c) 2016 Thomas Förster

# Class:: phpmyadmin
#
#
class phpmyadmin (
  $path     = '/srv/phpmyadmin',
  $user     = 'www-data',
  $revision = 'origin/STABLE',
  $servers  = [],
  $settings = [],
) {

  exec { "PMA install dir ${path}":
    user      => 'root',
    command   => "mkdir -p ${path}",
    unless    => "test -d ${path}",
    path      => ['/bin', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin'],
    logoutput => 'on_failure',
  }

  ->

  file { $path:
    ensure => directory,
    owner  => $user,
    group  => $user,
    mode   => '0755',
  }

  ->

  vcsrepo { $path:
    ensure   => latest,
    provider => 'git',
    source   => 'https://github.com/phpmyadmin/phpmyadmin.git',
    user     => $user,
    revision => $revision,
  }

  ->

  file { 'phpmyadmin-conf':
    path    => "${path}/config.inc.php",
    content => template('phpmyadmin/config.inc.php.erb'),
    owner   => $user,
  }

} # Class:: phpmyadmin
