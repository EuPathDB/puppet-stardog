require 'spec_helper'
describe 'stardog' do
  context 'with default values for all parameters' do
    it { should contain_class('stardog') }
  end
end
