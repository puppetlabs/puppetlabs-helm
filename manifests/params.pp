class helm::params {
  $version = undef
  $install_path = '/usr/bin'
  $init = true
  $service_account = 'tiller'
  $tiller_namespace = 'kube-system'
}