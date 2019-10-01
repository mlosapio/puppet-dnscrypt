# class: dnscrypt

class dnscrypt {

  package { 'dnscrypt-proxy':
    ensure => 'installed'
  }

  # hack for systemctl
  exec { 'dnscrypt-systemd-reload':
    command     => '/bin/systemctl daemon-reload',
    refreshonly => true,
  }

  # service
  service { 'dnscrypt':
    ensure    => running,
    provider  => systemd,
    enable    => true,
    hasstatus => true,
    require   => File['/etc/systemd/system/dnscrypt.service'],
  }

  # Systemd file
  file {'/etc/systemd/system/dnscrypt.service':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0744',
    source  => 'puppet:///modules/dnscrypt/dnscrypt.service',
    notify  => [
        Exec['dnscrypt-systemd-reload'],
        Service['dnscrypt'],
    ],
  }

}
