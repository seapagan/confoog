# rubocop:disable LineLength
require 'spec_helper'

describe Confoog do
  subject { Confoog::Settings }

  before(:all) do
    # create an internal STDERR so we can still test this but it will not
    # clutter up the output
    $original_stderr = $stderr
    $stderr = StringIO.new
  end

  after(:all) do
    $stderr = $original_stderr
  end

  it 'has a version number' do
    expect(Confoog::VERSION).not_to be nil
  end

  context 'when created', fakefs: true do
    before(:each) do
      # create fake dir and files
      FileUtils.mkdir_p('/home/tests')
      FileUtils.mkdir_p(File.expand_path('~/'))

      Dir.chdir('/home/tests') do
        File.new('.i_do_exist', 'w').close
      end
      Dir.chdir(File.expand_path('~/')) do
        File.new(Confoog::DEFAULT_CONFIG, 'w')
      end

      FileUtils.mkdir_p('/put/it/here')
      File.new('/put/it/here/.myconfigfile', 'w')
    end

    context 'with no parameters' do
      let(:settings) { subject.new }
      it 'should create the class with no errors' do
        expect(settings).to be_an_instance_of subject
        expect(settings.status[:errors]).to eq Confoog::ERR_NO_ERROR
      end
      it 'should set sensible defaults' do
        expect(settings.filename).to be Confoog::DEFAULT_CONFIG
        expect(settings.location).to eq '~/'
      end
    end

    context 'with parameters' do
      it 'should accept both location and filename' do
        settings = subject.new(filename: '.myconfigfile', location: '/put/it/here')
        expect(settings.filename).to eq '.myconfigfile'
        expect(settings.location).to eq '/put/it/here'
        expect(settings.status[:errors]).to eq Confoog::ERR_NO_ERROR
      end
      it 'should allow us to specify the default prefix for console messages and output this to STDERR' do
        expect($stderr).to receive(:puts).with(/^MyProg :/)
        subject.new(location: '/home/tests', filename: '.i_dont_exist', prefix: 'MyProg :')
      end
      it 'it should not output any messages if the quiet: option is passed.' do
        expect($stderr).not_to receive(:puts)
        subject.new(location: '/home/tests', filename: '.i_dont_exist', prefix: 'MyProg :', quiet: true)
      end
      it 'should allow us to change this at any time though' do
        settings = subject.new(location: '/home/tests', filename: '.i_dont_exist', prefix: 'MyProg :', quiet: true)
        settings.quiet = false
        expect($stderr).to receive(:puts) # not fussed what text, just that it exists
        settings.location = 'this will fail'
        expect(settings.quiet).to be false
      end
      it 'should return the full filename and path in .config_path' do
        settings = subject.new(location: '/home/tests', filename: '.i_do_exist')
        expect(settings.config_path).to eq '/home/tests/.i_do_exist'
      end
    end

    context 'it should check the existence of the specified configuration file' do
      it 'should set status[config_exists] to false if this does not exist' do
        settings = subject.new(location: '/home/tests', filename: '.i_dont_exist')
        expect(settings.status[:config_exists]).to be false
        expect(settings.status[:errors]).to eq Confoog::ERR_FILE_NOT_EXIST
      end
      it 'should set status[config_exists] to true if this does exist' do
        settings = subject.new(location: '/home/tests', filename: '.i_do_exist')
        expect(settings.status[:config_exists]).to be true
        expect(settings.status[:errors]).to eq Confoog::ERR_NO_ERROR
      end
      it 'should create this file if create_file: true is passed and file does not exist' do
        settings = subject.new(location: '/home/tests', filename: '.i_should_be_created', create_file: true)
        expect(settings.status[:config_exists]).to be true
        expect(File).to exist('/home/tests/.i_should_be_created')
        expect(settings.status[:errors]).to eq Confoog::INFO_FILE_CREATED
      end
      it 'should return a relevant error if the file was not able to be created' do
        # directory not exist
        settings = subject.new(location: '/directory/doesnt/exist', filename: '.i_wont_be_created', create_file: true)
        expect(settings.status[:errors]).to eq Confoog::ERR_CANT_CREATE_FILE
        expect(settings.status[:config_exists]).to be false
        expect(File).not_to exist('/directory/doesnt/exist/.i_wont_be_created')
        # directory not writeable
        # cant seem to get fakefs to change attributes on files so cant create
        # a read-only or not-owned file to test. Works on a real fs though.
      end
    end
  end

  context 'after created', fakefs: true do
    before(:each) do
      # create fake dir and files
      FileUtils.mkdir_p('/home/tests')
      Dir.chdir('/home/tests') do
        File.new('.i_do_exist', 'w').close
      end
    end

    it 'should not allow us to change the filename or location' do
      settings = subject.new(location: '/home/tests', filename: '.i_do_exist')
      settings.location = '/home/moretests'
      expect(settings.location).to eq '/home/tests'
      expect(settings.status[:errors]).to eq Confoog::ERR_CANT_CHANGE
      settings.filename = '.newfile'
      expect(settings.filename).to eq '.i_do_exist'
      expect(settings.status[:errors]).to eq Confoog::ERR_CANT_CHANGE
    end
  end
end
