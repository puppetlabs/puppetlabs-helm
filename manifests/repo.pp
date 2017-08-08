define helm::repo (
  $ensure = present,
  $repo_name = undef,
  $url = undef,
  $ca_file = undef,
  $cert_file = undef,
  $key_file = undef,
  $no_update = undef,
  $home = undef,
  $host = undef,
  $kube_context = undef,
  $tiller_namespace = 'kube-system',
){

  include helm::params

  if $ensure == present {
    $helm_repo_add_flags = helm_repo_add_flags({
      repo_name => $repo_name,
      url => $url,
      ca_file => $ca_file,
      cert_file => $cert_file,
      key_file => $key_file,
      no_update => $no_update,
      home => $home,
      host => $host,
      kube_context => $kube_context,
      tiller_namespace => $tiller_namespace,
    })
  }

  if $ensure == absent {
    $helm_repo_remove_flags = helm_repo_remove_flags({
      repo_name => $repo_name,
      home => $home,
      host => $host,
      kube_context => $kube_context,
      tiller_namespace => $tiller_namespace,
    })
  }

  if $ensure == present {
    $exec_repo = "helm repo ${helm_repo_add_flags}"
    $unless_repo = "helm repo list --tiller_namespace ${tiller_namespace} | awk '{if(NR>1)print ${1}}' | grep ${repo_name}"
  }
  elsif $ensure == absent {
    $exec_repo = "helm repo ${helm_repo_delete_flags}"
    $unless_repo = "helm repo list --tiller_namespace ${tiller_namespace} | awk '{if(NR>1)print ${1}}' | grep -v ${repo_name}"
  }

  exec { "Helm repo ${init}":
    command     => $exec_repo,
    environment => 'HOME=/root',
    path        => ['/bin', '/usr/bin'],
    timeout     => 0,
    unless      => $unless_repo,
  }

}