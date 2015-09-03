# rubocop:disable LineLength
require 'spec_helper'

describe Confoog::Settings, fakefs: true do
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

  before(:each) do
    # create fake dir and files
    FileUtils.mkdir_p('/home/tests')

    Dir.chdir('/home/tests') do
      test_hash = {}
      test_hash['location'] = '/home/tests'
      test_hash['recurse'] = true
      File.open('reference.yaml', 'w') do |file|
        file.write(test_hash.to_yaml)
      end
    end
  end

  context 'when writing config file' do
    it 'should not write to file unless there is actually config data' do
      s = subject.new(location: '/home/tests', create_file: true)
      expect($stderr).to receive(:puts).with(/empty/)
      s.save
      expect(File.size('/home/tests/.confoog')).to be 0
      expect(s.status[:errors]).to eq Confoog::ERR_NOT_WRITING_EMPTY_FILE
    end

    it 'should save an easy config to valid YAML' do
      s = subject.new(location: '/home/tests', create_file: true)
      s['location'] = '/home/tests'
      s['recurse'] = true
      s.save
      expect(FileUtils.compare_file('/home/tests/.confoog', '/home/tests/reference.yaml')).to be_truthy
    end
  end

  context 'when loading config file' do
    it 'should correctly load a simple YAML file' do
      s = subject.new(location: '/home/tests', filename: 'reference.yaml')
      s.load
      expect(s['location']).to eq '/home/tests'
      expect(s['recurse']).to eq true
    end

    it 'should complain if we try to load a non-existing file' do
      expect($stderr).to receive(:puts).with(/does not exist/)
      s = subject.new(location: '/home/tests', filename: '.i_dont_exist')
      expect($stderr).to receive(:puts).with(/Cannot load configuration data from/)
      s.load
      expect(s.status[:errors]).to eq Confoog::ERR_FILE_NOT_EXIST
    end

    it 'should comment if the file is empty' do
      s = subject.new(location: '/home/tests', create_file: true)
      expect($stderr).to receive(:puts).with(/empty/)
      s.load
      expect(s.status[:errors]).to eq Confoog::ERR_NOT_LOADING_EMPTY_FILE
    end
  end
end
