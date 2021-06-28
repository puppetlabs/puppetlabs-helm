# Defined Type helm::chart
#
# @summary
#   Manages the deployment of helm charts.
#
# @param ensure
#   Specifies whether a chart is deployed.
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
#   Specifies whether to simulate an installation or delete a deployment.
#   Values `true`, `false`.
#   
# @param env
#   Sets the environment variables for Helm to connect to the kubernetes cluster.
#   
# @param key_file
#   Identifies the HTTPS client using thie SSL key file.
#  
# @param key_ring
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
# @param kubeconfig
#   Path to the kubeconfig (v3 only)
#
# @param name_template
#   The template used to name the release.
#  
# @param no_hooks
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
# @param replace
#   Reuse the release name.
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
# @param tiller_namespace`
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
# @param tls_key`
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
define helm::chart (
  String $ensure                      = present,
  Optional[String] $ca_file           = undef,
  Optional[String] $cert_file         = undef,
  Optional[String] $chart             = undef,
  Boolean $debug                      = false,
  Boolean $devel                      = false,
  Boolean $dry_run                    = false,
  Optional[Array] $env                = undef,
  Optional[String] $key_file          = undef,
  Optional[String] $key_ring          = undef,
  Optional[String] $home              = undef,
  Optional[String] $host              = undef,
  Optional[String] $kube_context      = undef,
  Optional[String] $kubeconfig        = undef,
  Optional[String] $name_template     = undef,
  Optional[String] $namespace         = undef,
  Boolean $no_hooks                   = false,
  Optional[Array] $path               = undef,
  Boolean $purge                      = true,
  Boolean $replace                    = false,
  Optional[String] $repo              = undef,
  Optional[String] $release_name      = undef,
  Optional[Array] $set                = [],
  Optional[Integer] $timeout          = undef,
  Optional[String] $tiller_namespace  = 'kube-system',
  Boolean $tls                        = false,
  Optional[String] $tls_ca_cert       = undef,
  Optional[String] $tls_cert          = undef,
  Optional[String] $tls_key           = undef,
  Boolean $tls_verify                 = false,
  Optional[Array] $values             = [],
  Boolean $verify                     = false,
  Optional[String] $version           = undef,
  Boolean $wait                       = false,
){

  include ::helm::params

  if ($release_name == undef) {
    fail("\nYou must specify a name for the service with the release_name attribute \neg: release_name => 'mysql'")
  }

  if versioncmp($helm::version, '3.0.0') >= 0 {
    $_home = undef
    $_tiller_namespace = undef
    $_kubeconfig = $kubeconfig
  } else {
    $_home = $home
    $_tiller_namespace = $tiller_namespace
    $_kubeconfig = undef
  }

  if $ensure == present {
    $helm_install_flags = helm_install_flags({
      ensure => $ensure,
      ca_file =>$ca_file,
      cert_file => $cert_file,
      chart => $chart,
      debug => $debug,
      devel => $devel,
      dry_run => $dry_run,
      key_file => $key_file,
      key_ring => $key_ring,
      home => $home,
      host => $host,
      kube_context => $kube_context,
      kubeconfig => $_kubeconfig,
      name_template => $name_template,
      namespace => $namespace,
      no_hooks => $no_hooks,
      replace => $replace,
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
    $exec = "helm install ${name}"
    $exec_chart = "helm ${helm_install_flags}"
    $helm_ls_flags = helm_ls_flags({
      ls => true,
      home => $home,
      host => $host,
      kube_context => $kube_context,
      kubeconfig => $_kubeconfig,
      tiller_namespace => $_tiller_namespace,
      short => true,
      tls => $tls,
      tls_ca_cert => $tls_ca_cert,
      tls_cert => $tls_cert,
      tls_key => $tls_key,
      tls_verify => $tls_verify,
    })
    $unless_chart = "helm ${helm_ls_flags} | grep -q '^${release_name}$'"
  }

  if $ensure == absent {
    $helm_delete_flags = helm_delete_flags({
      ensure => $ensure,
      debug => $debug,
      dry_run => $dry_run,
      home => $home,
      host => $host,
      kube_context => $kube_context,
      kubeconfig => $_kubeconfig,
      name_template => $name_template,
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
      kubeconfig => $_kubeconfig,
      tiller_namespace => $_tiller_namespace,
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
