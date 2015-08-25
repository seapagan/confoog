# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'confoog/version'

Gem::Specification.new do |spec|
  spec.name          = "confoog"
  spec.version       = Confoog::VERSION
  spec.authors       = ["Seapagan"]
  spec.email         = ["seapagan@gmail.com"]

  spec.summary       = %q{Simple but complete Gem to add configuration files to your Ruby script / Gem}
  spec.description   = %q{WORK IN PROGRESS, No where near ready for use. This will add a class that takes care of all your configuration needs for Ruby scripts and Gems}
  spec.homepage      = "https://github.com/seapagan/confoog"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
