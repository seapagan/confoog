require 'spec_helper'

describe Confoog::Settings do
  subject { Confoog::Settings.new(quiet: true) }

  it 'allows the setting of arbitrary value pairs of any type' do
    subject[:first] = 'testing a string'
    expect(subject[:first]).to eq 'testing a string'
    subject[42] = true
    expect(subject[42]).to be true
    subject['array'] = [1, 2, 3, 4, 'test']
    expect(subject['array']).to be_an_instance_of(Array)
    expect(subject['array']).to eq [1, 2, 3, 4, 'test']
  end
  it 'returns nil if the variable does not exist' do
    expect(subject[:not_me]).to eq nil
  end
end
