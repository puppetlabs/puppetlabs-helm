require 'spec_helper'

describe 'helm::create', :type => :define do
  let(:title) { 'helm create' }
  let(:params) { {
                  'chart_path' => '/tmp',
                  'chart_name' => 'foo',
<<<<<<< HEAD
                  'path' => [ '/bin','/usr/bin']
=======
                  'path' => [ '/bin','/usr/bin'],
                  'home' => '/root',
                  'tiller_namespace' => 'kube-system',
                  'kubeconfig' => '/etc/kubernetes/admin.conf',
>>>>>>> f745a94... Add kubeconfig parameter for all defined types to better support Helm v3
               } }

  context 'with chart_path => /tmp and chart_name => foo' do
    it do
      is_expected.to compile.with_all_deps
<<<<<<< HEAD
      is_expected.to contain_exec('helm create foo').with_command("helm create '/tmp/foo'")
=======
      is_expected.to contain_exec('helm create foo').with_command("helm create --home '/root' --tiller-namespace 'kube-system' '/tmp/foo'")
    end

    context 'helm v3' do
      let(:pre_condition) { "class { 'helm': version => '3.5.0' }" }

      it do
        is_expected.to compile.with_all_deps
        is_expected.to contain_exec('helm create foo').with_command("helm create --kubeconfig '/etc/kubernetes/admin.conf' '/tmp/foo'")
      end
>>>>>>> f745a94... Add kubeconfig parameter for all defined types to better support Helm v3
    end
  end
end