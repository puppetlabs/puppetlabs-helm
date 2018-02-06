require 'spec_helper'

describe 'helm::helm_init', :type => :define do
  let(:title) { 'helm init' }

  context 'with init => true and service_account => tiller ' do
  let(:params) { {
                  'path' => [ '/bin','/usr/bin'],
                  'service_account' => 'tiller',
               } }
    it do
      is_expected.to compile.with_all_deps
      is_expected.to contain_exec('helm init').with_command("helm init --service-account 'tiller' --tiller-namespace 'kube-system'")
    end
  end

  context 'with upgrade => true' do
  let(:params) { {
                  'upgrade' => true,
                  'path' => [ '/bin','/usr/bin'],
                  'service_account' => 'tiller'
                  } }
    it do
      is_expected.to compile.with_all_deps
      is_expected.to contain_exec('helm init').with_command("helm init --service-account 'tiller' --tiller-namespace 'kube-system' --upgrade")
    end
  end

  context 'with overrides' do
    let(:params) {{
      'overrides' => [ "spec.template.spec.tolerations[0].key='node-role.kubernetes.io/master'", 
                     "spec.template.spec.tolerations[0].operator='Exists'" ],
      'path' => [ '/bin','/usr/bin'],
      'service_account' => 'tiller'
    }}
      it do
        is_expected.to compile.with_all_deps
        is_expected.to contain_exec('helm init').with_command("helm init --service-account 'tiller' --override spec.template.spec.tolerations[0].key='node-role.kubernetes.io/master',spec.template.spec.tolerations[0].operator='Exists' --tiller-namespace 'kube-system'")
      end
    end


  context 'with node-selectors' do
    let(:params) {{
      'node_selectors' => 'node-role.kubernetes.io/master=',
      'path' => [ '/bin','/usr/bin'],
      'service_account' => 'tiller'
    }}
    it do
      is_expected.to compile.with_all_deps
      is_expected.to contain_exec('helm init').with_command("helm init --service-account 'tiller' --node-selectors 'node-role.kubernetes.io/master=' --tiller-namespace 'kube-system'")
    end
  end

end
