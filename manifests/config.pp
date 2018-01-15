class helm::config (
  Array $env               = $helm::env,
  Boolean $init            = $helm::init,
  Array $path              = $helm::path,
  String $service_account  = $helm::service_account,
  String $tiller_namespace = $helm::tiller_namespace,
){

  helm::helm_init { 'kube-master':
    env              => $env,
    path             => $path,
    init             => $init,
    service_account  => $service_account,
    tiller_namespace => $tiller_namespace,
  }
}
