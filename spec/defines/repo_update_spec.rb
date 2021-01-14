require 'spec_helper'

describe 'helm::repo_update', :type => :define do
  let(:title) { 'helm repo update' }
  let(:params) { {
    'kubeconfig' => '/etc/kubernetes/admin.conf',
  } }

  context 'with default values for all params' do
    it { is_expected.to contain_exec('helm repo update').with_command('helm repo update') }
  end
<<<<<<< HEAD
end
=======

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
    it { is_expected.to contain_exec('helm repo update').with_command("helm repo --kubeconfig '/etc/kubernetes/admin.conf' update") }
  end
end
>>>>>>> f745a94... Add kubeconfig parameter for all defined types to better support Helm v3
