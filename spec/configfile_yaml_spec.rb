# rubocop:disable LineLength
require 'spec_helper'

describe Confoog::Settings, fakefs: true do
  subject { Confoog::Settings }

  before(:all) do
    # create an internal STDERR so we can still test this but it will not
    # clutter up the output
    # $original_stderr = $stderr
    # $stderr = StringIO.new
  end

  after(:all) do
    # $stderr = $original_stderr
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
      expect(s.status[:errors]).to eq Status::ERR_NOT_WRITING_EMPTY_FILE
    end

    it 'should by default save to disk if autosave: is not specified' do
      s = subject.new(location: '/home/tests', create_file: true)
      s['location'] = '/home/tests'
      expect(File.read('/home/tests/.confoog')).to include '/home/tests'
    end

    it 'should save an easy config to valid YAML' do
      s = subject.new(location: '/home/tests', create_file: true)
      s['location'] = '/home/tests'
      s['recurse'] = true
      s.save
      expect(FileUtils.compare_file('/home/tests/.confoog', '/home/tests/reference.yaml')).to be_truthy
    end

    it 'should return error status but raise no exception if it cannot write to the file' do
      s = subject.new(location: '/home/tests', create_file: true)
      s['location'] = '/home/tests'
      s['recurse'] = true
      File.delete(s.config_path)
      Dir.mkdir(s.config_path)
      expect($stderr).to receive(:puts).with(/Cannot/)
      s.save
      expect(s.status[:errors]).to eq Status::ERR_CANT_SAVE_CONFIGURATION
    end

    context 'when auto_save: true' do
      it 'should automatically save when a new variable is added' do
        s = subject.new(location: '/home/tests', create_file: true, autosave: true)
        s['location'] = '/home/tests'
        expect(File.read('/home/tests/.confoog')).to include '/home/tests'
      end

      it 'should automatically save when a variable is changed' do
        s = subject.new(location: '/home/tests', create_file: true, autosave: true)
        s['location'] = '/home/tests'
        s['location'] = '/usr/my/directory'
        expect(File.read('/home/tests/.confoog')).not_to include '/home/tests'
        expect(File.read('/home/tests/.confoog')).to include '/usr/my/directory'
      end

      it 'however should do none of this if autosave: false' do
        s = subject.new(location: '/home/tests', create_file: true, autosave: false)
        s['location'] = '/home/tests'
        expect(File.read('/home/tests/.confoog')).not_to include '/home/tests'
      end
    end

    context 'using the #autosave method before changing or adding variables' do
      it 'should correctly set and read the #autosave status' do
        s = subject.new(location: '/home/tests', create_file: true, autosave: true)
        s.autosave = false
        expect(s.autosave).to be false
        s.autosave = true
        expect(s.autosave).to be true
      end

      it 'should not save if #autosave is set false' do
        s = subject.new(location: '/home/tests', create_file: true, autosave: true)
        s.autosave = false
        s['location'] = '/home/tests'
        expect(File.read('/home/tests/.confoog')).not_to include '/home/tests'
      end

      it 'should save if #autosave is true' do
        s = subject.new(location: '/home/tests', create_file: true, autosave: false)
        s.autosave = true
        s['location'] = '/home/tests'
        expect(File.read('/home/tests/.confoog')).to include '/home/tests'
      end
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
      expect($stderr).to receive(:puts).with(/Cannot load configuration Data/)
      s.load
      expect(s.status[:errors]).to eq Status::ERR_CANT_LOAD
    end

    it 'should comment if the file is empty' do
      s = subject.new(location: '/home/tests', create_file: true)
      expect($stderr).to receive(:puts).with(/empty/)
      s.load
      expect(s.status[:errors]).to eq Status::ERR_NOT_LOADING_EMPTY_FILE
    end
  end

  context 'when created with auto_load: true' do
    it 'should automatically load the specified configuration file' do
      s = subject.new(location: '/home/tests', filename: 'reference.yaml', autoload: true)
      expect(s['location']).to eq '/home/tests'
      expect(s['recurse']).to be true
    end
  end

  context 'when created with auto_load: false' do
    it 'should not load the specified configuration file' do
      s = subject.new(location: '/home/tests', filename: 'reference.yaml', autoload: false)
      expect(s['location']).to be nil
      expect(s['recurse']).to be nil
    end
  end

  context 'when created without specifying an auto_load: value' do
    it 'should not load the specified configuration file' do
      s = subject.new(location: '/home/tests', filename: 'reference.yaml')
      expect(s['location']).to be nil
      expect(s['recurse']).to be nil
    end
  end
end
