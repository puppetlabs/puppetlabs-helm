require 'spec_helper'

describe 'helm::package', :type => :define do
  let(:facts) { {
                 :kernel       => 'Linux',
                 :architecture => 'amd64'
              } }
  let(:title) { 'helm package' }

  context 'with chart_name => foo & chart_path => /tmp' do
  let(:params) { {
                  'chart_path' => '/tmp',
                  'chart_name' => 'foo',
                  'path' => [ '/bin','/usr/bin'],
                  'home' => '/root',
                  'tiller_namespace' => 'kube-system',
               } }
    it do
      is_expected.to compile.with_all_deps
      is_expected.to contain_exec('helm package foo').with_command("helm package --home '/root' --save --tiller-namespace 'kube-system' '/tmp/foo'")
    end

    context 'helm v3' do
      let(:pre_condition) { "class { 'helm': version => '3.5.0' }" }

      it do
        is_expected.to compile.with_all_deps
        is_expected.to contain_exec('helm package foo').with_command("helm package --save '/tmp/foo'")
      end
    end
  end
end

