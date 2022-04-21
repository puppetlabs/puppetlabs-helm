# @summary
# helm::binary
#
# @api private
class helm::binary (
  String $version         = $helm::version,
  String $install_path    = $helm::install_path,
  Optional[String] $proxy = $helm::proxy,
  String $archive_baseurl = $helm::archive_baseurl,
) {
  case $::architecture {
    'amd64': {
      $arch = 'amd64'
    }
    'i386': {
      $arch = '386'
    }
    'x86_64': {
      $arch = 'amd64'
    }
    default: {
      fail("${::architecture} is not supported")
    }
  }

  $archive = "helm-v${version}-linux-${arch}.tar.gz"

  archive { 'helm':
    path            => "/tmp/${archive}",
    source          => "${archive_baseurl}/${archive}",
    extract_command => "tar xfz %s linux-${arch}/helm --strip-components=1 -O > ${install_path}/helm-${version}",
    extract         => true,
    extract_path    => $install_path,
    creates         => "${install_path}/helm-${version}",
    cleanup         => true,
    proxy_server    => $proxy,
  }

  file { "${install_path}/helm-${version}" :
    owner   => 'root',
    mode    => '0755',
    require => Archive['helm'],
  }

  file { "${install_path}/helm":
    ensure  => link,
    target  => "${install_path}/helm-${version}",
    require => File["${install_path}/helm-${version}"],
  }
}
