 define helm::config (
  $init = false,
  $client_only = undef,
  $dry_run = undef,
  $local_repo_url = undef,
  $net_host = undef,
  $service_account = undef,
  $skip_refresh = undef,
  $stable_repo_url = undef,
  $tiller_image = undef,
  $tiller_namespace = 'kube-system',
  $tiller_tls = undef,
  $tiller_tls_cert = undef,
  $tiller_tls_key = undef,
  $tls_ca_cert = undef,
  ){

  include helm::params

  if $init {
    $helm_init_flags = helm_init_flags({
      init => $init,
      client_only => $client_only,
      dry_run => $dry_run,
      local_repo_url => $local_repo_url,
      net_host => $net_host,
      service_account => $service_account,
      skip_refresh => $skip_refresh,
      stable_repo_url => $stable_repo_url,
      tiller_image => $tiller_image,
      tiller_namespace => $tiller_namespace,
      tiller_tls => $tiller_tls,
      tiller_tls_cert => $tiller_tls_cert,
      tiller_tls_key => $tiller_tls_key,
      tls_ca_cert => $tls_ca_cert,
    })
  }

  $exec_init = "helm ${helm_init_flags}"
  $unless_init = "kubectl get deployment --namespace=${tiller_namespace}  | grep 'tiller-deploy' "

  exec { 'Helm init':
    command     => $exec_init,
    environment => 'HOME=/root',
    path        => ['/bin', '/usr/bin'],
    timeout     => 0,
    unless      => $unless_init,
  }
}