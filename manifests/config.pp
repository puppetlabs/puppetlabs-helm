# @summary
# helm::config
#
# @api private
class helm::config (
  Boolean $canary_image                     = $helm::canary_image,
  Boolean $client_only                      = $helm::client_only,
  Boolean $debug                            = $helm::debug,
  Boolean $dry_run                          = $helm::dry_run,
  Array $env                                = $helm::env,
  Optional[String] $home                    = $helm::home,
  Optional[String] $host                    = $helm::host,
  Boolean $init                             = $helm::init,
  Optional[String] $kube_context            = $helm::kube_context,
  Optional[String] $local_repo_url          = $helm::local_repo_url,
  Boolean $net_host                         = $helm::net_host,
  Optional[String] $node_selectors          = $helm::node_selectors,
  Optional[Array] $overrides                = $helm::overrides,
  Array $path                               = $helm::path,
  String $service_account                   = $helm::service_account,
  Boolean $skip_refresh                     = $helm::skip_refresh,
  Optional[String] $stable_repo_url         = $helm::stable_repo_url,
  Optional[String] $tiller_image            = $helm::tiller_image,
  Array[String] $tiller_namespaces          = $helm::tiller_namespaces,
  Boolean $tiller_tls                       = $helm::tiller_tls,
  Optional[String] $tiller_tls_cert         = $helm::tiller_tls_cert,
  Optional[String] $tiller_tls_key          = $helm::tiller_tls_key,
  Boolean $tiller_tls_verify                = $helm::tiller_tls_verify,
  Optional[String] $tls_ca_cert             = $helm::tls_ca_cert,
  Boolean $upgrade                          = $helm::upgrade,
){

  $tiller_namespaces.each |$ns| {
    helm::helm_init { "helm-${ns}-master":
      canary_image     => $canary_image,
      client_only      => $client_only,
      debug            => $debug,
      env              => $env,
      dry_run          => $dry_run,
      home             => $home,
      host             => $host,
      init             => $init,
      kube_context     => $kube_context,
      local_repo_url   => $local_repo_url,
      net_host         => $net_host,
      node_selectors   => $node_selectors,
      overrides        => $overrides,
      path             => $path,
      service_account  => $service_account,
      skip_refresh     => $skip_refresh,
      stable_repo_url  => $stable_repo_url,
      tiller_image     => $tiller_image,
      tiller_namespace => $ns,
      tiller_tls       => $tiller_tls,
      tiller_tls_cert  => $tiller_tls_cert,
      tiller_tls_key   => $tiller_tls_key,
      tls_ca_cert      => $tls_ca_cert,
      upgrade          => $upgrade,
    }
  }
}
