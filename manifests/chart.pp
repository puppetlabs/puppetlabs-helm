define helm::chart (
  $ensure = present,
  $ca_file = undef,
  $cert_file = undef,
  $chart = undef,
  $devel = undef,
  $dry_run = undef,
  $key_file = undef,
  $key_ring = undef,
  $home = undef,
  $host = undef,
  $kube_context = undef,
  $name_template = undef,
  $namespace = undef,
  $no_hooks = undef,
  $replace = undef,
  $repo = undef,
  $service_name = undef,
  $set = undef,
  $timeout = undef,
  $tiller_namespace = 'kube-system',
  $tiller_tls = undef,
  $tiller_tls_cert = undef,
  $tiller_tls_key = undef,
  $tls = undef,
  $tls_ca_cert = undef,
  $tls_cert = undef,
  $tls_key = undef,
  $tls_verify = undef,
  $values = undef,
  $verify = undef,
  $version = undef,
  $wait = undef,
){

  include helm::params

  if ($service_name == undef) {
    fail("\nYou must specify a name for the service with the service_name attribute \neg: service_name => 'mysql'")
  }

  if $ensure == present {
    $helm_install_flags = helm_install_flags({
      ensure => $ensure,
      ca_file =>$ca_file,
      cert_file => $cert_file,
      chart => $chart,
      devel => $devel,
      dry_run => $dry_run,
      key_file => $key_file,
      key_ring => $key_ring,
      home => $home,
      host => $host,
      kube_context => $kube_context,
      name_template => $name_template,
      namespace => $namespace,
      no_hooks => $no_hooks,
      replace => $replace,
      repo => $repo,
      service_name => $service_name,
      set => $set,
      timeout => $timeout,
      tiller_namespace => $tiller_namespace,
      tiller_tls => $tiller_tls,
      tiller_tls_cert => $tiller_tls_cert,
      tiller_tls_key => $tiller_tls_key,
      tls => $tls,
      tls_ca_cert => $tls_ca_cert,
      tls_cert => $tls_cert,
      tls_key => $tls_key,
      tls_verify => $tls_verify,
      values => $values,
      verify => $verify,
      version => $version,
      wait => $wait,
      })
  }

  $exec_chart = "helm install ${helm_install_flags}"
  $unless_chart = "helm list --all | awk '{print $1"

  exec { $exec_chart :
    environment => 'HOME=/root',
    path        => ['/bin', '/usr/bin'],
    timeout     => 0,
  }

}