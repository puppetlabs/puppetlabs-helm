require 'spec_helper'

describe 'helm::config', :type => :class do
  context 'with default values for all parameters' do
    let(:params) { {
                    'canary_image'       => false,
                    'client_only'        => false,
                    'debug'              => false,
                    'dry_run'            => false,
                    'env'                => [ 'HOME=/root', 'KUBECONFIG=/root/admin.conf'],
                    'home'               => '/home/helm',
                    'host'               => 'host',
                    'init'               => true,
                    'kube_context'       => 'some_context',
                    'local_repo_url'     => 'some_repo',
                    'net_host'           => false,
                    'node_selectors'     => 'node_selector',
                    'overrides'          => [],
                    'path'               => [ '/bin','/usr/bin'],
                    'service_account'    => 'tiller',
                    'skip_refresh'       => false,
                    'stable_repo_url'    => 'stable.com',
                    'tiller_image'       => 'my_image',
                    'tiller_namespaces'  => ['kube-system'],
                    'tiller_tls'         => false,
                    'tiller_tls_cert'    => 'cert',
                    'tiller_tls_key'     => 'key',
                    'tiller_tls_verify'  => false,
                    'tls_ca_cert'        => 'ca_cert',
                    'upgrade'            => false,
                    'version'            => '2.5.1',
                    'install_path'       => '/usr/bin',
                 } }

    it do
      is_expected.to compile
      is_expected.to contain_helm__helm_init('helm-kube-system-master').with({
        'canary_image'       => 'false',
        'client_only'        => 'false',
        'debug'              => 'false',
        'dry_run'            => 'false',
        'env'                => [ 'HOME=/root', 'KUBECONFIG=/root/admin.conf'],
        'home'               => '/home/helm',
        'host'               => 'host',
        'init'               => 'true',
        'kube_context'       => 'some_context',
        'local_repo_url'     => 'some_repo',
        'net_host'           => 'false',
        'node_selectors'     => 'node_selector',
        'overrides'          => [],
        'path'               => [ '/bin','/usr/bin'],
        'service_account'    => 'tiller',
        'skip_refresh'       => 'false',
        'stable_repo_url'    => 'stable.com',
        'tiller_image'       => 'my_image',
        'tiller_namespace'   => 'kube-system',
        'tiller_tls'         => 'false',
        'tiller_tls_cert'    => 'cert',
        'tiller_tls_key'     => 'key',
        'tiller_tls_verify'  => 'false',
        'tls_ca_cert'        => 'ca_cert',
        'upgrade'            => 'false',
        'version'            => '2.5.1',
        'install_path'       => '/usr/bin',
      })
    end
  end
end
