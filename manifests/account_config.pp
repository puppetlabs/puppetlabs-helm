class helm::account_config (

){

  Exec {
    path        => ['/usr/bin', '/bin'],
    environment => [ 'HOME=/root', 'KUBECONFIG=/root/admin.conf'],
    logoutput   => true,
  }

  file {'/etc/kubernetes/tiller-serviceaccount.yaml':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('helm/tiller-serviceaccount.yaml.erb'),
  }

  exec {'create service account':
    command     => 'kubectl create -f tiller-serviceaccount.yaml',
    cwd         => '/etc/kubernetes',
    subscribe   => File['/etc/kubernetes/tiller-serviceaccount.yaml'],
    refreshonly => true,
    require     => File['/etc/kubernetes/tiller-serviceaccount.yaml'],
  }

  file {'/etc/kubernetes/tiller-clusterrole.yaml':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('helm/tiller-clusterrole.yaml.erb'),
  }

  exec {'create cluster role':
    command     => 'kubectl create -f tiller-clusterrole.yaml',
    cwd         => '/etc/kubernetes',
    subscribe   => File['/etc/kubernetes/tiller-clusterrole.yaml'],
    refreshonly => true,
    require     => File['/etc/kubernetes/tiller-clusterrole.yaml'],
  }
}

