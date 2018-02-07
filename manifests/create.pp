# == helm::create
define helm::create (
  Optional[String] $chart_name       = undef,
  Optional[String] $chart_path       = undef,
  Boolean $debug                     = false,
  Optional[Array] $env               = undef,
  Optional[String] $home             = undef,
  Optional[String] $host             = undef,
  Optional[String] $kube_context     = undef,
  Optional[Array] $path              = undef,
  Optional[String] $starter          = undef,
  Optional[String] $tiller_namespace = undef,
){

  include helm::params

  $helm_create_flags = helm_create_flags({
    chart_name => $chart_name,
    chart_path => $chart_path,
    debug => $debug,
    home => $home,
    host => $host,
    kube_context => $kube_context,
    starter => $starter,
    tiller_namespace => $tiller_namespace,
  })

  $exec_chart = "helm create ${helm_create_flags}"

  exec { "helm create ${chart_name}" :
    command     => $exec_chart,
    environment => $env,
    path        => $path,
    timeout     => 0,
    creates     => "${chart_path}/${chart_name}",
  }
}
