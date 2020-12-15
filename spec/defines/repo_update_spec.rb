require 'spec_helper'

describe 'helm::repo_update', :type => :define do
  let(:facts) { {
                 :kernel       => 'Linux',
                 :architecture => 'amd64'
              } }
  let(:title) { 'helm repo update' }

  context 'with default values for all params Helm v2' do
    let(:pre_condition) {
      "class { 'helm': version => '2.7.2' }"
    }
    it { is_expected.to contain_exec('helm repo update').with_command('helm repo update') }
  end

  context 'with home => /home and version => 2.7.2' do
    let(:pre_condition) {
      "class { 'helm': version => '2.7.2' }"
    }
    let(:params) { { 'home' => '/home' } }
    it { is_expected.to contain_exec('helm repo update').with_command("helm repo --home '/home' update") }
  end

  context 'with home => /home and version => 3.2.1' do
    let(:pre_condition) {
      "class { 'helm': version => '3.2.1' }"
    }
    it { is_expected.to contain_exec('helm repo update').with_command('helm repo update') }
  end
end
