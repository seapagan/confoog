# Confoog
[![Build Status](https://travis-ci.org/seapagan/confoog.svg)](https://travis-ci.org/seapagan/confoog)
[![Dependency Status](https://gemnasium.com/seapagan/confoog.svg)](https://gemnasium.com/seapagan/confoog)
[![Coverage Status](https://coveralls.io/repos/seapagan/confoog/badge.svg?branch=master&service=github)](https://coveralls.io/github/seapagan/confoog?branch=master)
[![Code Climate](https://codeclimate.com/github/seapagan/confoog/badges/gpa.svg)](https://codeclimate.com/github/seapagan/confoog)
[![Inline docs](http://inch-ci.org/github/seapagan/confoog.svg?branch=master)](http://inch-ci.org/github/seapagan/confoog)

A simple but complete Gem to add configuration files to your Ruby script / Gem

WORK IN PROGRESS, Nowhere near ready for use, and if fact currently does almost nothing! This will add a class that takes care of all your configuration needs for Ruby scripts and Gems.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'confoog'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install confoog

## Usage

```ruby
require 'confoog'

settings = Confoog::Settings.new
```
Confoog will take several parameters on creation, to specify the default config file and location. For example :
```ruby
settings = Confoog::Settings.new(location: '/home/myuser', filename: '.foo-settings')
```
There are other optional flags or variables that can be passed on creation:
```ruby
# Should a missing configuration file be created or not
create_file: true | false

# Specify an optional prefix before any error messages
prefix: 'My Application'

# Should we avoid outputting errors to the console? (ie in a GUI app)
quiet: true | false
```
If these are not specified, Confoog will use the following defaults :
```ruby
location: '~/'
filename: '.confoog'
create_file: false
prefix: 'Configuration'
quiet: false
```

## To Do

Thoughts in no particular order.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests (or simply `rake`). You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Versioning

This library aims to adhere to [Semantic Versioning 2.0.0][semver]. Violations
of this scheme should be reported as bugs. Specifically, if a minor or patch
version is released that breaks backward compatibility, that version should be
immediately yanked and/or a new version should be immediately released that
restores compatibility. Breaking changes to the public API will only be
introduced with new major versions. As a result of this policy, you can (and
should) specify a dependency on this gem using the [Pessimistic Version
Constraint][pvc] with two digits of precision. For example:

    spec.add_dependency 'confoog', '~> 1.0'

Of course, currently we have not even reached version 1, so expect any and all
of the API and interface to change!

[semver]: http://semver.org/
[pvc]: http://guides.rubygems.org/patterns/#pessimistic-version-constraint

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
