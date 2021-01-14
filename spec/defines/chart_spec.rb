require 'spec_helper'

describe 'helm::chart', :type => :define do
  let(:facts) { {
                 :kernel       => 'Linux',
                 :architecture => 'amd64'
              } }
  let(:title) { 'helm chart' }

 context 'with release_name => undef' do
   it do
     is_expected.to compile.and_raise_error(/\nYou must specify a name for the service with the release_name attribute \neg: release_name => 'mysql'/)
   end
 end

 context 'with ensure => present' do
  let(:params) { {
                 'ensure' => 'present',
                 'chart' => 'foo',
                 'path' => [ '/bin','/usr/bin'],
                 'release_name' => 'foo',
                 'home' => '/root',
                 'tiller_namespace' => 'kube-system',

               } }
    it do
      is_expected.to compile.with_all_deps
      is_expected.to contain_exec('helm install helm chart').with_command("helm install --home '/root' --name 'foo' --tiller-namespace 'kube-system' 'foo'")
    end

    context 'helm v3' do
      let(:pre_condition) { "class { 'helm': version => '3.5.0' }" }

      it do
        is_expected.to compile.with_all_deps
        is_expected.to contain_exec('helm install helm chart').with_command("helm install --name 'foo' 'foo'")
      end
    end
  end
  context 'with ensure => absent' do
  let(:params) { {
                 'ensure' => 'absent',
                 'path' => [ '/bin','/usr/bin'],
                 'release_name' => 'foo'

               } }
    it do
      is_expected.to compile.with_all_deps
      is_expected.to contain_exec('helm delete helm chart')
    end
  end
end
