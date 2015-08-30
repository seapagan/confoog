require 'spec_helper'

describe Confoog::Settings do

  subject {Confoog::Settings}

  before(:all) do
    # create an internal STDERR so we can still test this but it will not
    # clutter up the output
    $original_stderr = $stderr
    $stderr = StringIO.new
  end

  after(:all) do
    $stderr = $original_stderr
  end

  context "when writing config file", fakefs: true do

    before(:each) do
      # create fake dir and files
      FileUtils.mkdir_p("/home/tests")

      Dir.chdir("/home/tests") do
          File.open('reference.yaml', 'w') { |file|
            file.write("---\nlocation: \"/home/tests\"\nrecurse: true\n")
          }
      end
    end

    it 'should not write to file unless there is actually config data' do
      s = subject.new(location: "/home/tests", create_file: true)
      expect($stderr).to receive(:puts).with(/empty/)
      s.save
      expect(File.size("/home/tests/.confoog")).to be 0
      expect(s.status['errors']).to eq Confoog::ERR_NOT_WRITING_EMPTY_FILE
    end

    it 'should save an easy config to valid YAML' do
      s = subject.new(location: "/home/tests", create_file: true)
      s['location'] = "/home/tests"
      s['recurse'] = true
      s.save
      expect(FileUtils.compare_file('/home/tests/.confoog', '/home/tests/reference.yaml')).to be_truthy
    end
  end
end
