# == Class: helm::account_config 
class helm::account_config (
  Array $env                                         = $helm::env,
  Array $path                                        = $helm::path,
  String $service_account                            = $helm::service_account,
  Optional[Array[String]] $tiller_image_pull_secrets = $helm::tiller_image_pull_secrets,
  Array[String] $tiller_namespaces                   = $helm::tiller_namespaces,
){

  if (count($tiller_namespaces) > 1) {
    $_global_tiller = false
  } else {
    $_global_tiller = true
  }

  Exec {
    cwd         => '/etc/kubernetes',
    environment => $env,
    logoutput   => true,
    path        => $path,
  }

  file {'/etc/kubernetes/tiller-serviceaccount.yaml':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('helm/tiller-serviceaccount.yaml.epp', {
      'service_account'    => $service_account,
      'image_pull_secrets' => $tiller_image_pull_secrets, 
    }),
  }

  $tiller_namespaces.each |$ns| {
    exec {"create ${ns} tiller service account":
      command => "kubectl apply -n ${ns} -f tiller-serviceaccount.yaml",
      unless  => "kubectl get serviceaccount ${service_account} -n ${ns}",
      require => File['/etc/kubernetes/tiller-serviceaccount.yaml'],
    }
  }

  if $_global_tiller {
    file {'/etc/kubernetes/tiller-clusterrole.yaml':
      ensure  => 'file',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => epp('helm/tiller-clusterrole.yaml.epp', {
        'namespace'       => $tiller_namespaces[0],
        'service_account' => $service_account,
      }),
    }

    exec {'create cluster role':
      command => 'kubectl apply -f tiller-clusterrole.yaml',
      unless  => 'kubectl get clusterrolebinding tiller-cluster-rule',
      require => File['/etc/kubernetes/tiller-clusterrole.yaml'],
    }
  } else {
    $tiller_namespaces.each |$ns| {
      file {"/etc/kubernetes/tiller-${ns}-role.yaml":
        ensure  => 'file',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => epp('helm/tiller-role.yaml.epp', {
          'namespace'       => $ns,
          'service_account' => $service_account,
        }),
      }

      exec {"create ${ns} tiller role and binding":
        command => "kubectl apply -f tiller-${ns}-role.yaml",
        unless  => "kubectl get rolebinding tiller-binding -n ${ns}",
        require => File["/etc/kubernetes/tiller-${ns}-role.yaml"],
      }
    }
  }
}
