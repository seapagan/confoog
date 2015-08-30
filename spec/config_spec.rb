require 'spec_helper'

describe Confoog::Settings do

  subject {Confoog::Settings.new}

  before(:all) do
    # create an internal STDERR so we can still test this but it will not
    # clutter up the output
    $original_stderr = $stderr
    $stderr = StringIO.new
  end

  after(:all) do
    $stderr = $original_stderr
  end

  it "should allow the setting of arbitrary value pairs of any type" do
    subject[:first] = "testing a string"
    expect(subject[:first]).to eq "testing a string"
    subject[42] = true
    expect(subject[42]).to be true
    subject["array"] = [1, 2, 3, 4, "test"]
    expect(subject["array"]).to be_an_instance_of(Array)
    expect(subject["array"]).to eq [1,2,3,4, "test"]
  end
  it "should return nil if the variable does not exist" do
    expect(subject[:not_me]).to eq nil
  end
end
