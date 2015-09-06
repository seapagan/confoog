$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start

require 'pp' # work around https://github.com/defunkt/fakefs/issues/99
require 'confoog'
require 'fakefs/spec_helpers'

def show_file(filename)
  contents = File.open(filename, 'r') { |file| file.read }
  puts contents
end

RSpec.configure do |config|
  config.include FakeFS::SpecHelpers, fakefs: true
end
