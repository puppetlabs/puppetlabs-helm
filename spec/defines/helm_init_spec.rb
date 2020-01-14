require 'spec_helper'

describe 'helm::helm_init', :type => :define do
  let(:title) { 'helm init' }

  context 'with init => true and home => /home and service_account => tiller and and tiller_image => test and tiller_tls => true and tiller_tls_cert => cert and tiller_tls_key => key and tiller_tls_verify => true and version => 2.7.2' do
  let(:params) { {
                  'path' => [ '/bin','/usr/bin'],
                  'service_account' => 'tiller',
                  'home' => '/home',
                  'tiller_namespace' => 'kube-system',
                  'tiller_image' => 'test',
                  'tiller_tls' => true,
                  'tiller_tls_cert' => 'cert',
                  'tiller_tls_key' => 'key',
                  'tiller_tls_verify' => true,
                  'version' => '2.7.2',
               } }
    it do
      is_expected.to compile.with_all_deps
      is_expected.to contain_exec('helm kube-system init').with_command("helm init --home '/home' --service-account 'tiller' --tiller-image 'test' --tiller-namespace 'kube-system' --tiller-tls --tiller-tls-cert 'cert' --tiller-tls-key 'key'")
    end
  end

  context 'with upgrade => true' do
  let(:params) { {
                  'upgrade' => true,
                  'path' => [ '/bin','/usr/bin'],
                  'service_account' => 'tiller',
                  'tiller_namespace' => 'kube-system',
                  'version' => '2.7.2',
                  } }
    it do
      is_expected.to compile.with_all_deps
      is_expected.to contain_exec('helm kube-system init').with_command("helm init --service-account 'tiller' --tiller-namespace 'kube-system' --upgrade")
    end
  end

  context 'with overrides' do
    let(:params) {{
      'overrides' => [ "spec.template.spec.tolerations[0].key='node-role.kubernetes.io/master'", 
                     "spec.template.spec.tolerations[0].operator='Exists'" ],
      'path' => [ '/bin','/usr/bin'],
      'service_account' => 'tiller',
      'tiller_namespace' => 'kube-system',
      'version' => '2.7.2',
    }}
      it do
        is_expected.to compile.with_all_deps
        is_expected.to contain_exec('helm kube-system init').with_command("helm init --service-account 'tiller' --override spec.template.spec.tolerations[0].key='node-role.kubernetes.io/master',spec.template.spec.tolerations[0].operator='Exists' --tiller-namespace 'kube-system'")
      end
    end


  context 'with node-selectors' do
    let(:params) {{
      'node_selectors' => 'node-role.kubernetes.io/master=',
      'path' => [ '/bin','/usr/bin'],
      'service_account' => 'tiller',
      'tiller_namespace' => 'kube-system',
      'version' => '2.7.2',
    }}
    it do
      is_expected.to compile.with_all_deps
      is_expected.to contain_exec('helm kube-system init').with_command("helm init --service-account 'tiller' --node-selectors 'node-role.kubernetes.io/master=' --tiller-namespace 'kube-system'")
    end
  end
end
