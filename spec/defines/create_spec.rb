require 'spec_helper'

describe 'helm::create', :type => :define do
  let(:title) { 'helm create' }
  let(:params) { { :chart_path => '/tmp',
                   :chart_name => 'foo'
               } }

  context 'with default values for all parameters' do
    it do
      is_expected.to compile.with_all_deps
      is_expected.to contain_exec('helm create foo').with_command('helm create --tiller-namespace \'kube-system\' \'/tmp/foo\'')
    end
  end
end