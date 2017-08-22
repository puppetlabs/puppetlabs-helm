require 'spec_helper'

describe 'helm::config', :type => :class do

  let(:params) { { 'init' => true,
                   'service_account' => 'tiller',
                   'tiller_namespace' => 'kube-system',
               } }

  context 'with default values for all parameters' do
    it do
      is_expected.to compile
      is_expected.to contain_helm__helm_init('kube-master')
    end
  end
end