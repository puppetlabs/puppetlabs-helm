# Class: helm
# ===========================
#
# A module to install Helm, the Kubernetes package manager.
#
# Parameters
# ----------
#
# [*version*]
# The version of helm to install.
# Defaults to undefined
#
# [*install_path*]
# The path to extract helm binary to.
# Defaults to '/usr/bin'
#
# [*init*]
# Determines the behaviour of the config function. Setting to true will init the cluster and install tiller.
# False will install Helm in client only mode.
# Defaults to true
#
# [*service_aocount*]
# The service account for tiller
# Defaults to 'tiller'
#
# [*tiller_namesamce*]
# The namespace in which to install tiller
# Defaults to 'kube-system'
#
class helm (
  $version = $helm::params::version,
  $install_path = $helm::params::install_path,
  $init = $helm::params::init,
  $service_account = $helm::params::service_account,
  $tiller_namespace = $helm::params::tiller_namespace,
) inherits helm::params {

  validate_string($version)
  validate_string($install_path)
  validate_bool($init)
  validate_string($service_account)
  validate_string($tiller_namespace)
  validate_re($::kernel, 'Linux','This module only supports the Linux kernel')

  class { 'helm::binary': }
  -> class { 'helm::config': }

}
