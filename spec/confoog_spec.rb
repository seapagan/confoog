require 'spec_helper'

describe Confoog do

  subject {Confoog::Settings}

  it 'has a version number' do
    expect(Confoog::VERSION).not_to be nil
  end

  context "when created" do

    context "with no parameters" do
      let(:settings) {subject.new}
      it 'should create the class with no errors' do
        expect(settings).to be_an_instance_of subject
      end
      it 'should set sensible defaults' do
        expect(settings.config_filename).to be Confoog::DEFAULT_CONFIG
        expect(settings.config_location).to eq '~/'
      end
    end

    context "with parameters" do
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

    context 'it should check the existence of the specified configuration file', fakefs: true do

      before(:each) do
        # create fake dir and files
        FileUtils.mkdir_p("/home/tests")
        Dir.chdir("/home/tests") do
          File.new(".i_do_exist", "w").close
        end
      end

      it 'should set status[config_exists] to false if this does not exist' do
        settings=subject.new(location: '/home/tests', filename: '.i_dont_exist')
        expect(settings.status['config_exists']).to be false
      end
      it 'should set status[config_exists] to true if this does exist' do
        settings=subject.new(location: '/home/tests', filename: '.i_do_exist')
        expect(settings.status['config_exists']).to be true
      end
      it 'should create this file if create_file: true is passed and file does not exist' do
        settings=subject.new(location: '/home/tests', filename: '.i_should_be_created', create_file: true)
        expect(settings.status['config_exists']).to be true
        expect(File).to exist('/home/tests/.i_should_be_created')
      end
    end
  end

  context 'after created', fakefs: true do

    before(:each) do
      # create fake dir and files
      FileUtils.mkdir_p("/home/tests")
      Dir.chdir("/home/tests") do
        File.new(".i_do_exist", "w").close
      end
    end

    it "should not allow us to change the filename or location" do
      settings=subject.new(location: '/home/tests', filename: '.i_do_exist')
      settings.config_location = '/home/moretests'
      expect(settings.config_location).to eq '/home/tests'
      settings.config_filename = '.newfile'
      expect(settings.config_filename).to eq '.i_do_exist'
    end
  end
end
