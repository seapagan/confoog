require 'spec_helper'

describe Confoog do

  subject {Confoog::Settings}

  it 'has a version number' do
    expect(Confoog::VERSION).not_to be nil
  end

  context "When created with no parameters" do
    let(:settings) {subject.new}
    it 'should create the class with no errors' do
      expect(settings).to be_an_instance_of subject
    end
    it 'should set sensible defaults' do
      #settings=subject.new
      expect(settings.config_filename).to be Confoog::DEFAULT_CONFIG
      expect(settings.config_location).to eq '~/'
    end
  end
  context "When created with parameters" do
    it 'should accept a location for the configuration file' do
      settings=subject.new(location: '/home/user/configs')
      expect(settings.config_location).to eq '/home/user/configs'
    end
    it 'should accept a filename for the configuration file' do
      settings=subject.new(filename: '.configfile')
      expect(settings.config_filename).to eq '.configfile'
    end
    it 'should accept both location and filename' do
      settings=subject.new(filename: '.myconfigfile', location: '/put/it/here')
      expect(settings.config_filename).to eq '.myconfigfile'
      expect(settings.config_location).to eq '/put/it/here'
    end
  end

end
