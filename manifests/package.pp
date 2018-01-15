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
  Optional[Array] $path               = undef,
  Boolean $save                       = true,
  Boolean $sign                       = false,
  Optional[String] $tiller_namespace  = undef,
  Optional[String] $version           = undef,
){

  include helm::params

  $helm_package_flags = helm_package_flags({
    chart_name => $chart_name,
    chart_path => $chart_path,
    debug => $debug,
    dependency_update => $dependency_update,
    destination => $destination,
    home => $home,
    host => $host,
    key => $key,
    keystring => $keystring,
    kube_context => $kube_context,
    save => $save,
    sign => $sign,
    tiller_namespace => $tiller_namespace,
    version => $version,
    })


  $exec_package = "helm package ${helm_package_flags}"

  exec { "helm package ${chart_name}":
    command     => $exec_package,
    environment => $env,
    path        => $path,
    timeout     => 0,
    creates     => "${destination}/${chart_name}-${version}.tgz"
  }
}
