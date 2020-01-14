
# Defined Type helm::helm_init
#
# @summary
#   Deploys the Tiller pod and initializes the Helm client.
#
# @param init
#   Specifies whether to deploy the tiller pod and initialise the Helm client.
#   Valid values are `true`, `false`.
# 
# @param canary_image
#   Specifies whether to use the canary Tiller image.
#   Valid values are `true`, `false`.
# 
# @param client_only
#   Specifies whether to deploy Tiller.
#   Valid values are `true`, `false`.
# 
# @param debug
#   Specifies whether to enable the verbose output.
#   Values `true`, `false`.
# 
# @param dry_run
#   Specifies whether to simulate an installation or delete of a deployment.
#   Values `true`, `false`.
# 
# @param env
#   Sets the environment variables required for Helm to connect to the kubernetes cluster.
# 
# @param home
#   The location for your Helm configuration. This value overrides `$HELM_HOME`.
#
# @param host
#   The host address for Tiller. Overrides `$HELM_HOST`.
# 
# @param kube_context
#   The name for the kubeconfig context to use.
# 
# @param local_repo_url
#   The local repository URL.
# 
# @param net_host
#   Specifies whether to install Tiller with `net=host`.
#   Valid values are `true`, `false`.
# 
# @param path
#   The PATH variable used for exec types.
# 
# @param service_account
#   The name for the service account used for deploying Tiller.
# 
# @param skip_refresh
#   Specifies whether to refresh or download the local repository cache.
#   Valid values are `true`, `false`.
# 
# @param stable_repo_url
#   The stable repository URL.
# 
# @param tiller_image
#   Override the Tiller image.
# 
# @param tiller_namespace
#   Namespace for Tiller.
# 
# @param tiller_tls
#   Specifies whether to install Tiller with TLS enabled.
#   Valid values are `true`, `false`.
# 
# @param tiller_tls_cert
#   The path to the TLS certificate file that is installed with Tiller.
# 
# @param tiller_tls_key
#   The path to the TLS key file that is installed with Tiller.
# 
# @param tiller_tls_verify
#   Specifies whether to install Tiller with TLS enabled and to verify remote certificates.
#   Valid values are `true`, `false`.
# 
# @param tls_ca_cert
#   Specifies whether to use the path to the CA root certificate.
#   Valid values are `true`, `false`.
# 
# @param upgrade
#   Specifies whether to upgrade if Tiller is installed.
#   Valid values are `true`, `false`.
# 
# @param version
#   Specifies the version to install
#   default is 2.7.2
#  
# @param install_path
#   Specifies the install_path of helm executable
#   default to '/usr/bin'
# 
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
  Optional[String] $version          = undef,
  Optional[String] $install_path     = undef,
){

  include ::helm::params

  if $init {

    $versioninfo = split($version, '.')

    if (Integer($version[0]) < 3) {
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
}
