require 'spec_helper'

describe 'helm::repo', :type => :define do
  let(:title) { 'helm repo' }

  context 'with ensure => present and repo_name => foo and username => bar and password => bar and home => /home and version => 2.7.2' do
    let(:params) { {
                    'ensure' => 'present',
                    'env' => ['HOME=/root', 'KUBECONFIG=/root/admin.conf'],
                    'path' => [ '/bin','/usr/bin'],
                    'username' => 'bar',
                    'password' => 'bar',
                    'repo_name' => 'foo',
                    'home' => '/home',
                    'url' => 'https://foo.com/bar',
                    'version' => '2.7.2'
                 } }
    it do
      is_expected.to compile.with_all_deps
      is_expected.to contain_exec('helm repo foo').with_command("helm repo add --home '/home' --username 'bar' --password 'bar' 'foo' 'https://foo.com/bar'")
    end
  end
  context 'with ensure => present and repo_name => foo and username => bar and password => bar and home => /home (not used with v3) and version => 3.2.1' do
    let(:params) { {
                    'ensure' => 'present',
                    'env' => ['HOME=/root', 'KUBECONFIG=/root/admin.conf'],
                    'path' => [ '/bin','/usr/bin'],
                    'username' => 'bar',
                    'password' => 'bar',
                    'repo_name' => 'foo',
                    'home' => '/home',
                    'url' => 'https://foo.com/bar',
                    'version' => '3.2.1'
                 } }
    it do
      is_expected.to compile.with_all_deps
      is_expected.to contain_exec('helm repo foo').with_command("helm repo add --username 'bar' --password 'bar' 'foo' 'https://foo.com/bar'")
    end
  end
  context 'with ensure => absent and repo_name => foo and home => /home and version => 2.7.2' do
    let(:params) { {
                    'ensure' => 'absent',
                    'env' => ['HOME=/root', 'KUBECONFIG=/root/admin.conf'],
                    'path' => [ '/bin','/usr/bin'],
                    'repo_name' => 'foo',
                    'home' => '/home',
                    'version' => '2.7.2'
                 } }
    it do
      is_expected.to compile.with_all_deps
      is_expected.to contain_exec('helm repo foo').with_command(/helm repo remove --home '\/home' 'foo'/)
    end
  end
  context 'with ensure => absent and repo_name => foo and home => /home (not used with v3) and version => 3.2.1' do
    let(:params) { {
                    'ensure' => 'absent',
                    'env' => ['HOME=/root', 'KUBECONFIG=/root/admin.conf'],
                    'path' => [ '/bin','/usr/bin'],
                    'repo_name' => 'foo',
                    'home' => '/home',
                    'version' => '3.2.1'
                 } }
    it do
      is_expected.to compile.with_all_deps
      is_expected.to contain_exec('helm repo foo').with_command(/helm repo remove 'foo'/)
    end
  end
end

