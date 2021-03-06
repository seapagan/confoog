# rubocop:disable LineLength
require 'spec_helper'

describe Confoog::Settings, fakefs: true do
  subject { Confoog::Settings }

  before(:all) do
    # create an internal STDERR so we can still test this but it will not
    # clutter up the output
    @original_stderr = $stderr
    $stderr = StringIO.new
  end

  after(:all) do
    $stderr = @original_stderr
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
    it 'does not write to file unless there is actually config data' do
      s = subject.new(location: '/home/tests', create_file: true)
      expect($stderr).to receive(:puts).with(/empty/)
      s.save
      expect(File.size('/home/tests/.confoog')).to be 0
      expect(s.status[:errors]).to eq Status::ERR_NOT_WRITING_EMPTY_FILE
    end

    it 'does not create a missing file, that would be done by #new if requested' do
      s = subject.new(location: '/home/tests', filename: '.i_dont_exist', create_file: false)
      s['test'] = 'this should not save'
      s.save # put this in just to make sure both manual and autosave work as spec.
      expect(File.exist?(s.config_path)).to be false
    end

    it 'by default saves to disk if autosave: is not specified' do
      s = subject.new(location: '/home/tests', create_file: true)
      s['location'] = '/home/tests'
      expect(File.read('/home/tests/.confoog')).to include '/home/tests'
    end

    it 'saves an easy config to valid YAML' do
      s = subject.new(location: '/home/tests', create_file: true)
      s['location'] = '/home/tests'
      s['recurse'] = true
      s.save
      expect(FileUtils.compare_file('/home/tests/.confoog', '/home/tests/reference.yaml')).to be_truthy
    end

    it 'returns error status but raise no exception if it cannot write to the file' do
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
      it 'automatically saves when a new variable is added' do
        s = subject.new(location: '/home/tests', create_file: true, autosave: true)
        s['location'] = '/home/tests'
        expect(File.read('/home/tests/.confoog')).to include '/home/tests'
      end

      it 'automatically saves when a variable is changed' do
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
      it 'correctly sets and read the #autosave status' do
        s = subject.new(location: '/home/tests', create_file: true, autosave: true)
        s.autosave = false
        expect(s.autosave).to be false
        s.autosave = true
        expect(s.autosave).to be true
      end

      it 'does not save if #autosave is set false' do
        s = subject.new(location: '/home/tests', create_file: true, autosave: true)
        s.autosave = false
        s['location'] = '/home/tests'
        expect(File.read('/home/tests/.confoog')).not_to include '/home/tests'
      end

      it 'saves if #autosave is true' do
        s = subject.new(location: '/home/tests', create_file: true, autosave: false)
        s.autosave = true
        s['location'] = '/home/tests'
        expect(File.read('/home/tests/.confoog')).to include '/home/tests'
      end
    end
  end

  context 'when loading config file' do
    it 'correctly loads a simple YAML file' do
      s = subject.new(location: '/home/tests', filename: 'reference.yaml')
      s.load
      expect(s['location']).to eq '/home/tests'
      expect(s['recurse']).to eq true
    end

    it 'complains if we try to load a non-existing file' do
      expect($stderr).to receive(:puts).with(/does not exist/)
      s = subject.new(location: '/home/tests', filename: '.i_dont_exist')
      expect($stderr).to receive(:puts).with(/Cannot load configuration Data/)
      s.load
      expect(s.status[:errors]).to eq Status::ERR_CANT_LOAD
    end

    it 'comments if the file is empty' do
      s = subject.new(location: '/home/tests', create_file: true)
      expect($stderr).to receive(:puts).with(/empty/)
      s.load
      expect(s.status[:errors]).to eq Status::ERR_NOT_LOADING_EMPTY_FILE
    end
  end

  context 'when created with auto_load: true' do
    it 'automatically loads the specified configuration file' do
      s = subject.new(location: '/home/tests', filename: 'reference.yaml', autoload: true)
      expect(s['location']).to eq '/home/tests'
      expect(s['recurse']).to be true
    end
  end

  context 'when created with auto_load: false' do
    it 'does not load the specified configuration file' do
      s = subject.new(location: '/home/tests', filename: 'reference.yaml', autoload: false)
      expect(s['location']).to be nil
      expect(s['recurse']).to be nil
    end
  end

  context 'when created without specifying an auto_load: value' do
    it 'does not load the specified configuration file' do
      s = subject.new(location: '/home/tests', filename: 'reference.yaml')
      expect(s['location']).to be nil
      expect(s['recurse']).to be nil
    end
  end
end
