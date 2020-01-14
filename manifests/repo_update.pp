# == helm::repo_update
define helm::repo_update (
  Boolean $debug                     = false,
  Optional[Array] $env               = undef,
  Optional[String] $home             = undef,
  Optional[String] $host             = undef,
  Optional[String] $kube_context     = undef,
  Optional[Array] $path              = undef,
  Optional[String] $tiller_namespace = undef,
  Boolean $update                    = true,
  Optional[String] $version          = $helm::params::version,
){

  include ::helm::params

  $versioninfo = split($version, '.')

  if (Integer($version[0]) < 3) {
    if $update {
      $helm_repo_update_flags = helm_repo_update_flags({
        debug => $debug,
        home => $home,
        host => $host,
        kube_context => $kube_context,
        tiller_namespace => $tiller_namespace,
        update => $update,
      })
      $exec_update = "helm repo ${helm_repo_update_flags}"
    }
  } else {
    if $update {
      $helm_repo_update_flags = helm_repo_update_flags({
        debug => $debug,
        host => $host,
        kube_context => $kube_context,
        tiller_namespace => $tiller_namespace,
        update => $update,
      })
      $exec_update = "helm repo ${helm_repo_update_flags}"
    }
  }

  exec { 'helm repo update':
    command     => $exec_update,
    environment => $env,
    path        => $path,
    timeout     => 0,
  }
}
