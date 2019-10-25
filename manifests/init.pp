# Class: helm
# ===========================
#
# A module to install Helm, the Kubernetes package manager.
#
# Parameters
# ----------
#
# [*canary_image]
# Use the helm canary image for the default init of helm.
# Defaults to false
#
# [*client_only]
# Make the default init install the client only.
# Defaults to false
#
# [*debug*]
# Set output logging to debug for the default init.
# Defaults to false
#
# [*dry_run*]
# Make the default init run in dry-run mode.
# Defaults to false
#
# [*env*]
# Environment variables to specify the location of configruation files, or any other custom variables required for helm to run.
# Defaults to [ 'HOME=/root', 'KUBECONFIG=/root/admin.conf']
#
# [*home*]
# Set the HELM_HOME variable for the default init.
# Defaults to undef
#
# [*host*]
# Specify the HELM_HOST for the default init.
# Defaults to undef
#
# [*init*]
# Determines the behaviour of the config function. Setting to true will init the cluster and install tiller.
# False will install Helm in client only mode.
# Defaults to true

# [*install_path*]
# The path to extract helm binary to.
# Defaults to '/usr/bin'
#
# [*kube_context*]
# Specify the kube_context for the default init.
# Defaults to undef
#
# [*local_repo_url*]
# Specify the local_repo_url for the default init.
# Defaults to undef
#
# [*net_host*]
# Enable net_host mode for the default init.
# Defaults to false
#
# [*node_selectors*]
# Specify node selectors for the helm init on the default init.
# Defaults to undef
#
# [*overrides*]
# Specify override parameters for the default init.
# Defaults to undef
#
# [*path*]
# The PATH variable used for exec types.
# Defaults to ['/bin','/usr/bin']
#
# [*proxy*]
# Specify an internet proxy if necessary.
# Defaults to undef
#
# [*service_account*]
# The service account for tiller
# Defaults to 'tiller'
#
# [*skip_refresh*]
# Enable skip refresh mode for the default init.
# Defaults to false
#
# [*stable_repo_url*]
# Specify the stable repo url for the default init.
# Defaults to undef
#
# [*tiller_image*]
# Specify the image for the tiller install in the default init.
# Defaults to undef
# 
# [*tiller_namespaces*]
# Array of namespaces in which to install tiller
# Defaults to ['kube-system']
#
# [*tiller_tls*]
# Enable TLS for tiller in the default init.
# Defaults to false
#
#
# [*tiller_tls_cert*]
# Specify a TLS cert for tiller in the default init.
# Defaults to undef
#
# [*tiller_tls_key*]
# Specify a TLS key for tiller in the default init.
# Defaults to undef
#
# [*tiller_tls_verify*]
# Enable TLS verification for tiller in the default init.
# Defaults to undef
#
# [*tls_ca_cert*]
# Specify a TLS CA certificate for tiller in the default init.
# Defaults to undef
#
# [*upgrade*]
# Whether to upgrade tiller in the default init.
# Defaults to false
#
# [*version*]
# The version of helm to install.
# Defaults to 2.5.1
#
# [*archive_baseurl*]
# The base URL for downloading the helm archive, must contain file helm-v${version}-linux-${arch}.tar.gz
# Defaults to https://kubernetes-helm.storage.googleapis.com
# URLs supported by puppet/archive module will work, e.g. puppet:///modules/helm_files
#
class helm (
  Boolean $canary_image                     = $helm::params::canary_image,
  Boolean $client_only                      = $helm::params::client_only,
  Boolean $debug                            = $helm::params::debug,
  Boolean $dry_run                          = $helm::params::dry_run,
  Array $env                                = $helm::params::env,
  Optional[String] $home                    = $helm::params::home,
  Optional[String] $host                    = $helm::params::host,
  Boolean $init                             = $helm::params::init,
  String $install_path                      = $helm::params::install_path,
  Optional[String] $kube_context            = $helm::params::kube_context,
  Optional[String] $local_repo_url          = $helm::params::local_repo_url,
  Optional[String] $proxy                   = $helm::params::proxy,
  Optional[Boolean] $net_host               = $helm::params::net_host,
  Optional[String] $node_selectors          = $helm::params::node_selectors,
  Optional[Array] $overrides                = $helm::params::overrides,
  Array $path                               = $helm::params::path,
  String $service_account                   = $helm::params::service_account,
  Boolean $skip_refresh                     = $helm::params::skip_refresh,
  Optional[String] $stable_repo_url         = $helm::params::stable_repo_url,
  Array[String] $tiller_namespaces          = $helm::params::tiller_namespaces,
  Optional[String] $tiller_image            = $helm::params::tiller_image,
  Boolean $tiller_tls                       = $helm::params::tiller_tls,
  Optional[String] $tiller_tls_cert         = $helm::params::tiller_tls_cert,
  Optional[String] $tiller_tls_key          = $helm::params::tiller_tls_key,
  Boolean $tiller_tls_verify                = $helm::params::tiller_tls_verify,
  Optional[String]  $tls_ca_cert            = $helm::params::tls_ca_cert,
  Boolean $upgrade                          = $helm::params::upgrade,
  String $version                           = $helm::params::version,
  String $archive_baseurl                   = $helm::params::archive_baseurl,
) inherits helm::params {

  if $::kernel {
    assert_type(Pattern[/Linux/], $::kernel) |$a, $b| {
      fail(translate('This module only supports the Linux kernel'))
    }
  }

  contain ::helm::binary
  contain ::helm::config

  if $client_only == false {
    contain ::helm::account_config
    Class['helm::binary']
      -> Class['helm::account_config']
      -> Class['helm::config']
  }
  else{
    Class['helm::binary']
      -> Class['helm::config']
  }

}
