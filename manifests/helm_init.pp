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

  helm::chart { 'stable/mysql':
    ensure       => absent,
    chart        => 'stable/mysql',
    release_name => 'dave-release',
  }
}