class helm::helm_init (
  $init = $helm::init,
  $service_account = $helm::service_account,
  $tiller_namespace = $helm::tiller_namespace,
) {
  helm::config { 'kube-controller':
    init             => $init,
    service_account  => $service_account,
    tiller_namespace => $tiller_namespace,
  }

  helm::repo { 'Bitnami':
    ensure => present,
    repo_name => 'Bitnami',
    url => 'https://github.com/bitnami/charts',
  }

  helm::repo_update {'update':
    update => true,
  }

}