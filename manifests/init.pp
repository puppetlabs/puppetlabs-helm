# Class: helm
# ===========================
#
# A module to install Helm, the Kubernetes package manager.
#
# Parameters
# ----------
#
# [*env*]
# Environment variables to specify the location of configruation files, or any other custom variables required for helm to run.
# Defaults to [ 'HOME=/root', 'KUBECONFIG=/root/admin.conf']
#
# [*init*]
# Determines the behaviour of the config function. Setting to true will init the cluster and install tiller.
# False will install Helm in client only mode.
# Defaults to true
#
# [*install_path*]
# The path to extract helm binary to.
# Defaults to '/usr/bin'
#
# [*path*]
# The PATH variable used for exec types
# Defaults to ['/bin','/usr/bin']
#
# [*init*]
# Determines the behaviour of the config function. Setting to true will init the cluster and install tiller.
# False will install Helm in client only mode.
# Defaults to true
#
# [*service_account*]
# The service account for tiller
# Defaults to 'tiller'
#
# [*tiller_namesamce*]
# The namespace in which to install tiller
# Defaults to 'kube-system'
#
# [*version*]
# The version of helm to install.
# Defaults to 2.5.1
#

class helm (
  Array $env               = $helm::params::env,
  Boolean $init            = $helm::params::init,
  String $install_path     = $helm::params::install_path,
  Array $path              = $helm::params::path,
  String $service_account  = $helm::params::service_account,
  String $tiller_namespace = $helm::params::tiller_namespace,
  String $version          = $helm::params::version,
  Boolean $client_only     = false,
) inherits helm::params {

  if $::kernel {
    assert_type(Pattern[/Linux/], $::kernel) |$a, $b| {
      fail('This module only supports the Linux kernel')
    }
  }

  contain helm::binary
  contain helm::config

  if $client_only == false {
    contain helm::account_config
    Class['helm::binary']
      -> Class['helm::account_config']
      -> Class['helm::config']
  }
  else{
    Class['helm::binary']
      -> Class['helm::config']
  }

}
