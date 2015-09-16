require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'reek/rake/task'
require 'inch/rake'

RSpec::Core::RakeTask.new(:spec)

RuboCop::RakeTask.new do |task|
  task.options << 'lib'
end

Inch::Rake::Suggest.new do |suggest|
  suggest.args << '--pedantic'
end

Reek::Rake::Task.new do |t|
  t.fail_on_error = false
  t.verbose       = true
  t.reek_opts     = '-U'
end

task default: [:rubocop, :inch, :reek, :spec]
