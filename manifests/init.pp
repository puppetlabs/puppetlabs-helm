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
# Defaults to /usr/bin
# 
# [*init*]
# Determines the behaviour of the config function. Setting to true will init the cluster and install tiller. False will install Helm in client only mode.
# Defaults to true
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'helm':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2017 Your name here, unless otherwise noted.
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

  class { 'helm::package': }
  class { 'helm::helm_init': }
}
