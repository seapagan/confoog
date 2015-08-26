$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'pp' # work around https://github.com/defunkt/fakefs/issues/215
require 'confoog'
require 'fakefs/spec_helpers'

RSpec.configure do |config|
  config.include FakeFS::SpecHelpers, fakefs: true
end
