
# Defined Type helm::chart::update
#
# @summary
#   Update the deployed Helm charts.
#
# @param ensure
#   Specifies whether a chart must be updated.
#   Valid values are 'present', 'absent'.
# 
# @param ca_file
#   Verifies the certificates of the HTTPS-enabled servers using the CA bundle.
# 
# @param cert_file
#   Identifies the HTTPS client using this SSL certificate file.
# 
# @param debug
#   Specifies whether to enable verbose output.
#   Values `true`, `false`.
# 
# @param devel
#   Specifies whether to use development versions.
#   Values `true`, `false`.
# 
# @param dry_run
#   Specifies whether to simulate a chart update.
#   Values `true`, `false`.
# 
# @param env
#   Sets the environment variables for Helm to connect to the kubernetes cluster.
# 
# @param install
#   If a release by this name doesn't already exist, run an install
# 
# @param key_file
#   Identifies the HTTPS client using the SSL key file.
# 
# @param keyring
#   Location of the public keys that are used for verification.
# 
# @param home
#   Location of your Helm config. This value overrides `$HELM_HOME`.
# 
# @param host
#   Address of Tiller. This value overrides `$HELM_HOST`.
# 
# @param kube_context
#   Name of the kubeconfig context.
# 
# @param recreate_pods
#   Performs pods restart for the resource if applicable
# 
# @param reset_values
#   When upgrading, reset the values to the ones built into the chart
# 
# @param reuse_values
#   when upgrading, reuse the last release's values, and merge in any new values. If '--reset-values' is specified, this is ignored.
# 
# @param no_hooks# @param 
#   Specifies whether to prevent hooks running during the installation.
#   Values `true`, `false`.
# 
# @param path
#   The PATH variable used for exec types.
# 
# @param purge
#   Specifies whether to remove the release from the store, and make its name available for later use.
#   Values `true`, `false`.
# 
# @param release_name
#   **Required.** The release name.
# 
# @param repo
#   The repository URL for a requested chart.
# 
# @param set
#   The set array of values for the `helm create` command.
# 
# @param timeout
#   The timeout in seconds to wait for a Kubernetes operation.
# 
# @param tiller_namespace
#   The Tiller namespace.
# 
# @param tls
#   Specifies whether to enable TLS.
#   Values `true`, `false`.
# 
# @param tls_ca_cert
#   The path to TLS CA certificate file.
# 
# @param tls_cert
#   The path to TLS certificate file.
# 
# @param tls_key
#   The path to TLS key file.
# 
# @param tls_verify
#   Enable TLS for request and verify remote.
# 
# @param values
#   Specify values from a YAML file. Multiple values in an array are accepted.
# 
# @param verify
#   Specifies whether to verify the package before installing it.
#   Values `true`, `false`.
# 
# @param version
#   Specify the version of the chart to install. `undef` installs the latest version.
# 
# @param wait
#   Before marking the release as successful, specify whether to wait until all the pods, PVCs, services, and the minimum number of deployment pods are in a ready state. The `timeout` value determines the duration.
#   Values `true`, `false`.
# 
# @param chart
#   The file system location of the package.
#
define helm::chart_update (
  String $ensure                  = present,
  Optional[String] $ca_file       = undef,
  Optional[String] $cert_file     = undef,
  Optional[String] $chart         = undef,
  Boolean $debug                  = false,
  Boolean $devel                  = false,
  Boolean $dry_run                = false,
  Optional[Array] $env            = undef,
  Optional[String] $key_file      = undef,
  Optional[String] $keyring       = undef,
  Optional[String] $home          = undef,
  Optional[String] $host          = undef,
  Boolean $install                = true,
  Optional[String] $kube_context  = undef,
  Optional[String] $namespace     = undef,
  Boolean $no_hooks               = false,
  Array $path                     = undef,
  Boolean $purge                  = true,
  Optional[String] $repo          = undef,
  Optional[String] $release_name  = undef,
  Optional[String] $recreate_pods = undef,
  Optional[String] $reset_values  = undef,
  Optional[String] $reuse_values  = undef,
  Optional[Array] $set            = [],
  Optional[Integer] $timeout      = undef,
  String $tiller_namespace        = 'kube-system',
  Boolean $tls                    = false,
  Optional[String] $tls_ca_cert   = undef,
  Optional[String] $tls_cert      = undef,
  Optional[String] $tls_key       = undef,
  Boolean $tls_verify             = false,
  Optional[Array] $values         = [],
  Boolean $verify                 = false,
  Optional[String] $version       = undef,
  Boolean $wait                   = false,
){

  include ::helm::params

  if ($release_name == undef) {
    fail(translate("\nYou must specify a name for the service with the release_name attribute \neg: release_name => 'mysql'"))
  }

  if $ensure == present {
    $helm_chart_update_flags = helm_chart_update_flags({
      ensure => $ensure,
      ca_file =>$ca_file,
      cert_file => $cert_file,
      chart => $chart,
      debug => $debug,
      devel => $devel,
      dry_run => $dry_run,
      key_file => $key_file,
      keyring => $keyring,
      home => $home,
      host => $host,
      install => $install,
      kube_context => $kube_context,
      namespace => $namespace,
      no_hooks => $no_hooks,
      recreate_pods => $recreate_pods,
      reset_values => $reset_values,
      reuse_values => $reuse_values,
      repo => $repo,
      release_name => $release_name,
      set => $set,
      timeout => $timeout,
      tiller_namespace => $tiller_namespace,
      tls => $tls,
      tls_ca_cert => $tls_ca_cert,
      tls_cert => $tls_cert,
      tls_key => $tls_key,
      tls_verify => $tls_verify,
      values => $values,
      verify => $verify,
      version => $version,
      wait => $wait,
      })
    $exec = "helm upgrade ${name}"
    $exec_chart = "helm ${helm_chart_update_flags}"
    $unless_chart = undef
  }

  if $ensure == absent {
    $helm_delete_flags = helm_delete_flags({
      ensure => $ensure,
      debug => $debug,
      dry_run => $dry_run,
      home => $home,
      host => $host,
      kube_context => $kube_context,
      namespace => $namespace,
      no_hooks => $no_hooks,
      purge => $purge,
      release_name => $release_name,
      timeout => $timeout,
      tiller_namespace => $tiller_namespace,
      tls => $tls,
      tls_ca_cert => $tls_ca_cert,
      tls_cert => $tls_cert,
      tls_key => $tls_key,
      tls_verify => $tls_verify,
      })
    $exec = "helm delete ${name}"
    $exec_chart = "helm ${helm_delete_flags}"
    $helm_ls_flags = helm_ls_flags({
      ls => true,
      home => $home,
      host => $host,
      kube_context => $kube_context,
      tiller_namespace => $tiller_namespace,
      short => true,
      tls => $tls,
      tls_ca_cert => $tls_ca_cert,
      tls_cert => $tls_cert,
      tls_key => $tls_key,
      tls_verify => $tls_verify,
    })
    $unless_chart = "helm ${helm_ls_flags} | awk '{if(\$1 == \"${release_name}\") exit 1}'"
  }

  exec { $exec:
    command     => $exec_chart,
    environment => $env,
    path        => $path,
    timeout     => 0,
    tries       => 10,
    try_sleep   => 10,
    unless      => $unless_chart,
  }
}
