require 'spec_helper'

describe CliMechanic do
  it 'should have a version number' do
    expect(CliMechanic::VERSION).not_to be_nil
  end

  it 'should do something useful' do
    expect(true).to be_truthy
  end
end
