define helm::repo (
  $ensure = present,
  $ca_file = undef,
  $cert_file = undef,
  $debug = false,
  $key_file = undef,
  $no_update = undef,
  $home = undef,
  $host = undef,
  $kube_context = undef,
  $tiller_namespace = 'kube-system',
  $repo_name = undef,
  $url = undef,
){

  include helm::params

  if $ensure == present {
    $helm_repo_add_flags = helm_repo_add_flags({
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
    $exec = 'helm repo add'
    $exec_repo = "helm repo ${helm_repo_add_flags}"
    $unless_repo = "helm repo list --tiller_namespace ${tiller_namespace} | awk '{if(NR>1)print ${1}}' | grep ${repo_name}"
  }

  if $ensure == absent {
    $helm_repo_remove_flags = helm_repo_remove_flags({
      home => $home,
      host => $host,
      kube_context => $kube_context,
      repo_name => $repo_name,
      tiller_namespace => $tiller_namespace,
    })
    $exec = 'helm repo delete'
    $exec_repo = "helm repo ${helm_repo_delete_flags}"
    $unless_repo = "helm repo list --tiller_namespace ${tiller_namespace} | awk '{if (\$1 == \"${repo_name}\") exit 1}'"
  }

  exec { $exec:
    command     => $exec_repo,
    environment => 'HOME=/root',
    path        => ['/bin', '/usr/bin'],
    timeout     => 0,
    unless      => $unless_repo,
  }
}