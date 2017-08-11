class helm::binary (
  $version      = $helm::version,
  $install_path = $helm::install_path,
){

  case $::architecture {
    'amd64': {
      $arch = 'amd64'
    }
    'i386': {
      $arch = '386'
    }
    default: {
      fail("${::architecture} is not supported")
    }
  }

  $filename = "helm-v${version}-linux-${arch}.tar.gz"

  archive { 'helm':
    path            => "/tmp/${filename}",
    source          => "https://kubernetes-helm.storage.googleapis.com/${filename}",
    extract_command => "tar xfz %s linux-${arch}/helm --strip-components=1",
    extract         => true,
    extract_path    => $install_path,
    creates         => "${install_path}/helm",
    cleanup         => true,
  }

  file { "${install_path}/helm":
    owner   => 'root',
    mode    => '0755',
    require => Archive['helm']
  }
}