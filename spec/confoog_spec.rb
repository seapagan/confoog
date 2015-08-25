require 'spec_helper'

describe Confoog do

  subject {Confoog::Settings}

  it 'has a version number' do
    expect(Confoog::VERSION).not_to be nil
  end

  it 'should accept no options when created but should set sensible defaults' do
    settings=subject.new
    expect(settings).to be_an_instance_of subject
    expect(settings.config_filename).to be Confoog::DEFAULT_CONFIG
    expect(settings.config_location).to eq '~/'
  end

  it 'should also accept the location and filename on creation, either separate or together' do
    settings=subject.new(location: '/home/user/configs')
    expect(settings.config_location).to eq '/home/user/configs'
    settings=subject.new(filename: '.configfile')
    expect(settings.config_filename).to eq '.configfile'
    settings=subject.new(filename: '.myconfigfile', location: '/put/it/here')
    expect(settings.config_filename).to eq '.myconfigfile'
    expect(settings.config_location).to eq '/put/it/here'
  end

  
end
