require 'spec_helper'
describe 'helm' do
  context 'with default values for all parameters' do
    it { should contain_class('helm') }
  end
end
