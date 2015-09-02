# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'confoog/version'

Gem::Specification.new do |spec|
  spec.name          = 'confoog'
  spec.version       = Confoog::VERSION
  spec.authors       = ['Seapagan']
  spec.email         = ['seapagan@gmail.com']

  spec.summary       = 'A simple Gem to add YAML configuration files to your Ruby script / Gem'
  spec.description   = 'A WORK IN PROGRESS, Nowhere near ready for use, and if fact currently will neither load nor save the configuration to file!'
  spec.homepage      = 'https://github.com/seapagan/confoog'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    fail 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'fakefs'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'rubocop'
end
