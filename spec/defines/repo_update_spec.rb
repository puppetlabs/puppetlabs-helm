require 'spec_helper'

describe 'helm::repo_update', :type => :define do
  let(:title) { 'helm repo update' }

  context 'with default values for all params Helm v2' do
  let(:params) { {
                 'version' => '2.7.2',
               } }
    it { is_expected.to contain_exec('helm repo update').with_command('helm repo update') }
  end
end