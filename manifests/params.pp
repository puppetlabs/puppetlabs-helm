# == Class: helm::params
class helm::params {
  $canary_image              = false
  $client_only               = false
  $debug                     = false
  $dry_run                   = false
  $env                       = [ 'HOME=/root', 'KUBECONFIG=/etc/kubernetes/admin.conf']
  $home                      = undef
  $host                      = undef
  $init                      = true
  $install_path              = '/usr/bin'
  $kube_context              = undef
  $local_repo_url            = undef
  $proxy                     = undef
  $net_host                  = false
  $node_selectors            = undef
  $overrides                 = undef
  $path                      = [ '/bin','/usr/bin']
  $service_account           = 'tiller'
  $skip_refresh              = false
  $stable_repo_url           = undef
  $tiller_image              = undef
  $tiller_image_pull_secrets = []
  $tiller_namespaces         = ['kube-system']
  $tiller_tls                = false
  $tiller_tls_cert           = undef
  $tiller_tls_key            = undef
  $tiller_tls_verify         = false
  $tls_ca_cert               = undef
  $upgrade                   = false
  $version                   = '2.7.2'
  $archive_baseurl           = 'https://get.helm.sh'
}
