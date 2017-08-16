define helm::repo (
  $ensure = present,
  $ca_file = undef,
  $cert_file = undef,
  $debug = false,
  $key_file = undef,
  $no_update = false,
  $home = undef,
  $host = undef,
  $kube_context = undef,
  $tiller_namespace = undef,
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
    $exec_repo = "helm repo add ${helm_repo_add_flags}"
    $unless_repo = "helm repo list --tiller-namespace ${tiller_namespace} | awk '{if(NR>1)print \$1}' | grep -w ${repo_name}"
  }

  if $ensure == absent {
    $helm_repo_remove_flags = helm_repo_remove_flags({
      home => $home,
      host => $host,
      kube_context => $kube_context,
      repo_name => $repo_name,
      tiller_namespace => $tiller_namespace,
    })
    $exec_repo = "helm repo delete ${helm_repo_delete_flags}"
    $unless_repo = "helm repo list --tiller_namespace ${tiller_namespace} | awk '{if (\$1 == \"${repo_name}\") exit 1}'"
  }

  exec { 'helm repo':
    command     => $exec_repo,
    environment => $env,
    path        => $path,
    timeout     => 0,
    unless      => $unless_repo,
    logoutput   => true,
  }
}