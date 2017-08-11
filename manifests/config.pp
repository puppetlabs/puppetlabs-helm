class helm::config (
  $init = $helm::init,
  $service_account = $helm::service_account,
  $tiller_namespace = $helm::tiller_namespace,
){
  
  helm::helm_init { 'kube-master':
    init             => $init,
    service_account  => $service_account,
    tiller_namespace => $tiller_namespace,
  }
}