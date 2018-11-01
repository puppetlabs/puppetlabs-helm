# == helm::repo
define helm::repo (
  String $ensure                     = present,
  Optional[String] $ca_file          = undef,
  Optional[String] $cert_file        = undef,
  Boolean $debug                     = false,
  Optional[Array] $env               = undef,
  Optional[String] $key_file         = undef,
  Boolean $no_update                 = false,
  Optional[String] $home             = undef,
  Optional[String] $host             = undef,
  Optional[String] $kube_context     = undef,
  Optional[Array] $path              = undef,
  Optional[String] $tiller_namespace = undef,
  Optional[String] $repo_name        = undef,
  Optional[String] $url              = undef,
){

  include ::helm::params

  if $ensure == present {
    $helm_repo_add_flags = helm_repo_add_flags({
      ensure => $ensure,
      ca_file => $ca_file,
      cert_file => $cert_file,
      debug => $debug,
      key_file => $key_file,
      no_update => $no_update,
      home => $home,
      host => $host,
      kube_context => $kube_context,
      tiller_namespace => $tiller_namespace,
      repo_name => $repo_name,
      url => $url,
    })
    $exec_repo = "helm repo ${helm_repo_add_flags}"
    $unless_repo = "helm repo list | awk '{if(NR>1)print \$1}' | grep -w ${repo_name}"
  }

  if $ensure == absent {
    $helm_repo_remove_flags = helm_repo_remove_flags({
      ensure => $ensure,
      home => $home,
      host => $host,
      kube_context => $kube_context,
      repo_name => $repo_name,
      tiller_namespace => $tiller_namespace,
    })
    $exec_repo = "helm repo ${helm_repo_remove_flags}"
    $unless_repo = "helm repo list | awk '{if (\$1 == \"${repo_name}\") exit 1}'"
  }

  exec { "helm repo ${repo_name}":
    command     => $exec_repo,
    environment => $env,
    path        => $path,
    timeout     => 0,
    unless      => $unless_repo,
    logoutput   => true,
  }
}
