require 'spec_helper'

describe 'helm::create', :type => :define do
  let(:facts) { {
                 :kernel       => 'Linux',
                 :architecture => 'amd64'
              } }
  let(:title) { 'helm create' }
  let(:params) { {
                  'chart_path' => '/tmp',
                  'chart_name' => 'foo',
                  'path' => [ '/bin','/usr/bin'],
                  'home' => '/root',
                  'tiller_namespace' => 'kube-system',
                  'kubeconfig' => '/etc/kubernetes/admin.conf',
               } }

  context 'with chart_path => /tmp and chart_name => foo' do
    it do
      is_expected.to compile.with_all_deps
      is_expected.to contain_exec('helm create foo').with_command("helm create --home '/root' --tiller-namespace 'kube-system' '/tmp/foo'")
    end

    context 'helm v3' do
      let(:pre_condition) { "class { 'helm': version => '3.5.0' }" }

      it do
        is_expected.to compile.with_all_deps
        is_expected.to contain_exec('helm create foo').with_command("helm create --kubeconfig '/etc/kubernetes/admin.conf' '/tmp/foo'")
      end
    end
  end
end