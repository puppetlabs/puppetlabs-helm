class helm::account_config (

){

  file {'/etc/kubernetes/tiller-sa.yaml':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('helm/tiller-sa.yaml'),
  }

  exec {'create service account':
    command => 'kubectl create -f tiller-sa.yaml',
    cwd => '/etc/kubernetes',
    subscribe => File['/etc/kubernetes/tiller-sa.yaml'],
  }

  file {'/etc/kubernetes/tiller-clusterrole.yaml':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('helm/tiller-clusterrole.yaml'),
  }

  exec {'create cluster role':
    command => 'kubectl create -f tiller-clusterrole.yaml',
    cwd => '/etc/kubernetes',
    subscribe => File['/etc/kubernetes/tiller-clusterrole.yaml'],
  }

}

