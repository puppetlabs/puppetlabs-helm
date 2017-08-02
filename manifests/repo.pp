define helm::repo (
  $ensure = present,  
  $repo_name = undef,
  $url = undef,
  $update = undef,
  $ca_file = undef,
  $cert_file = undef,
  $key_file = undef, 
  $no_update = undef,
  $home = undef,                
  $host = undef,                
  $kube_context = undef,        
  $tiller_namespace = undef, 
){

  include helm::params
  
  if $ensure == present {
    $helm_add_repo_flags = helm_add_repo_flags({
      repo_name => $repo_name,
      url => $url,
      update => $update,
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

  
}