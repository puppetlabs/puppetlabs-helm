# == helm::helm_init 
define helm::helm_init (
  Boolean $init                      = true,
  Boolean $canary_image              = false,
  Boolean $client_only               = false,
  Boolean $debug                     = false,
  Boolean $dry_run                   = false,
  Optional[Array] $env               = undef,
  Optional[String] $home             = undef,
  Optional[String] $host             = undef,
  Optional[String] $kube_context     = undef,
  Optional[String] $local_repo_url   = undef,
  Boolean $net_host                  = false,
  Optional[Array] $path              = undef,
  Optional[String] $service_account  = undef,
  Boolean $skip_refresh              = false,
  Optional[String] $stable_repo_url  = undef,
  Optional[Array] $overrides         = undef,
  Optional[String] $node_selectors   = undef,
  Optional[String] $tiller_image     = undef,
  String $tiller_namespace           = 'kube-system',
  Boolean $tiller_tls                = false,
  Optional[String] $tiller_tls_cert  = undef,
  Optional[String] $tiller_tls_key   = undef,
  Boolean $tiller_tls_verify         = false,
  Optional[String] $tls_ca_cert      = undef,
  Boolean $upgrade                   = false,
){

  include ::helm::params

  if $init {
    $helm_init_flags = helm_init_flags({
      init             => $init,
      canary_image     => $canary_image,
      client_only      => $client_only,
      debug            => $debug,
      dry_run          => $dry_run,
      home             => $home,
      host             => $host,
      kube_context     => $kube_context,
      local_repo_url   => $local_repo_url,
      net_host         => $net_host,
      service_account  => $service_account,
      skip_refresh     => $skip_refresh,
      stable_repo_url  => $stable_repo_url,
      overrides        => $overrides,
      node_selectors   => $node_selectors,
      tiller_image     => $tiller_image,
      tiller_namespace => $tiller_namespace,
      tiller_tls       => $tiller_tls,
      tiller_tls_cert  => $tiller_tls_cert,
      tiller_tls_key   => $tiller_tls_key,
      tls_ca_cert      => $tls_ca_cert,
      upgrade          => $upgrade,
    })

    if $home != undef {
      $is_client_init_cmd = "test -d ${home}/plugins"
    }
    else {
      $is_client_init_cmd = 'test -d ~/.helm/plugins'
    }

    if $client_only == false {
      $is_server_init_cmd = "kubectl get deployment --namespace=${tiller_namespace}  | grep 'tiller-deploy'"
    } else {
      $is_server_init_cmd = true
  }

    $exec_init = "helm ${helm_init_flags}"
    $unless_init = "${is_client_init_cmd} && ${is_server_init_cmd}"

    exec { "helm ${tiller_namespace} init":
      command     => $exec_init,
      environment => $env,
      path        => $path,
      logoutput   => true,
      timeout     => 0,
      unless      => $unless_init,
    }
  }
}
