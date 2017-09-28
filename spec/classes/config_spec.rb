require 'spec_helper'

describe 'helm::config', :type => :class do

  context 'with default values for all parameters' do
    let(:params) { {
                    'env' => [ 'HOME=/root', 'KUBECONFIG=/root/admin.conf'],
                    'init' => true,
                    'path' => [ '/bin','/usr/bin'],
                    'service_account' => 'tiller',
                    'tiller_namespace' => 'kube-system',
                 } }
    it do
      is_expected.to compile
      is_expected.to contain_helm__helm_init('kube-master').with({
        'init' => 'true',
        'path' => [ '/bin','/usr/bin'],
        'service_account' => 'tiller',
        'tiller_namespace' => 'kube-system',
      })
    end
  end
end