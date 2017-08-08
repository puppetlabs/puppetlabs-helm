define helm::repo_update (
  $update = true,
  $home = undef,
  $host = undef,
  $kube_context = undef,
  $tiller_namespace = 'kube-system',
){

  include helm::params

  if $update {
    $helm_repo_update_flags = helm_repo_update_flags({
      update => $update,
      home => $home,
      host => $host,
      kube_context => $kube_context,
      tiller_namespace => $tiller_namespace,
    })
  }

  if $update {
    $exec_update = "helm repo ${helm_repo_update_flags}"
  }

  exec { 'Helm repo update':
    command     => $exec_update,
    environment => 'HOME=/root',
    path        => ['/bin', '/usr/bin'],
    timeout     => 0,
  }

}