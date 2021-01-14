# Defined Type helm::package
#
# @summary
#   Packages a chart directory ino a chart archive..
#
# @param chart_name
#   Defaults to `undef`.
#   The name of the Helm chart.
#
# @param chart_path
#   The file system location of the chart.
# 
# @param debug
#   Specifies whether to enable verbose output.
#   Values `true`, `false`.
#   Defaults to `false`.
#
# @param home
#   Location of your Helm config. This value overrides `$HELM_HOME`.
#   Defaults to `undef`.
# 
# @param `host`
#   The address for Tiller. This value overrides `$HELM_HOST`.
#   Defaults to `undef`.
#
# @param kube_context
#   The name for the kubeconfig context.
#   Defaults to `undef`.
# 
# @param kubeconfig
#   Path to the kubeconfig (v3 only)
#
# @param save
#   Specifies whether to save the packaged chart to the local chart repository.
#   Valid values are `true`, `false`.
#   Defaults to `true`.
#
# @param sign
#   Specifies whether to use a PGP private key to sign the package.
#   Valid values are `true`, `false`.
#   Defaults to `false`.
#
# @param tiller_namespace
#   The namespace for Tiller.
#   Defaults to `undef`.
# 
# @param version
#   The version of the chart.
#   Defaults to `undef`.
# 
# @param dependency_update
#   Specifies whether to update dependencies.
#   Valid values are `true`, `false`.
#   Defaults to `false`.
# 
# @param destination
#   The destination location to write to.
#   Defaults to `undef`.
# 
# @param env
#   Sets the environment variables required for Helm to connect to the kubernetes cluster.
#    Defaults to `undef`.
#
# @param key
#   Specify the key to use.
#   Defaults to `undef`.
#
# @param keystring
#   The location of the public keys that are used for verification.
#   Defaults to `undef`.
#
define helm::package (
  Optional[String] $chart_name        = undef,
  Optional[String] $chart_path        = undef,
  Boolean $debug                      = false,
  Boolean $dependency_update          = false,
  Optional[String] $destination       = undef,
  Optional[Array] $env                = undef,
  Optional[String] $home              = undef,
  Optional[String] $host              = undef,
  Optional[String] $key               = undef,
  Optional[String] $keystring         = undef,
  Optional[String] $kube_context      = undef,
  Optional[String] $kubeconfig        = undef,
  Optional[Array] $path               = undef,
  Boolean $save                       = true,
  Boolean $sign                       = false,
  Optional[String] $tiller_namespace  = undef,
  Optional[String] $version           = undef,
){

  include ::helm
  include ::helm::params

  if versioncmp($helm::version, '3.0.0') >= 0 {
    $_home = undef
    $_tiller_namespace = undef
    $_kubeconfig = $kubeconfig
  } else {
    $_home = $home
    $_tiller_namespace = $tiller_namespace
    $_kubeconfig = undef
  }

  $helm_package_flags = helm_package_flags({
    chart_name => $chart_name,
    chart_path => $chart_path,
    debug => $debug,
    dependency_update => $dependency_update,
    destination => $destination,
    home => $_home,
    host => $host,
    key => $key,
    keystring => $keystring,
    kube_context => $kube_context,
    kubeconfig => $_kubeconfig,
    save => $save,
    sign => $sign,
    tiller_namespace => $_tiller_namespace,
    version => $version,
    })


  $exec_package = "helm package ${helm_package_flags}"

  exec { "helm package ${chart_name}":
    command     => $exec_package,
    environment => $env,
    path        => $path,
    timeout     => 0,
    creates     => "${destination}/${chart_name}-${version}.tgz",
  }
}
