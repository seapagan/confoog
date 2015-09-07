# Confoog
[![Gem Version](https://badge.fury.io/rb/confoog.svg)](http://badge.fury.io/rb/confoog)
[![Build Status](https://travis-ci.org/seapagan/confoog.svg)](https://travis-ci.org/seapagan/confoog)
[![Dependency Status](https://gemnasium.com/seapagan/confoog.svg)](https://gemnasium.com/seapagan/confoog)
[![Coverage Status](https://coveralls.io/repos/seapagan/confoog/badge.svg?branch=master&service=github)](https://coveralls.io/github/seapagan/confoog?branch=master)
[![Code Climate](https://codeclimate.com/github/seapagan/confoog/badges/gpa.svg)](https://codeclimate.com/github/seapagan/confoog)
[![Inline docs](http://inch-ci.org/github/seapagan/confoog.svg?branch=master)](http://inch-ci.org/github/seapagan/confoog)

A simple Gem to add YAML configuration files to your Ruby script / Gem.

__*Note : While this Gem is fully functional, the API may be subject to changes before hitting version 1.0.0*__

This Gem allows your Ruby scripts and Gems to save and load its settings to a configuration file in YAML format.

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
Currently Confoog will not allow 'nested' configuration types, however each variable can be an array or hash so multiple settings can be recorded for each variable and accessed (for a hash) by `settings[variable][hash_key]` or array using `settings[array].each`. In other words, treat the return from `settings[var]` as the type it contains. See examples below.

```ruby
require 'confoog'

settings = Confoog::Settings.new
settings[:var] = value
settings[:array] = [1, 2, 3, 4]
settings[42] = "Meaning of life"
settings[:urls] = ["https://www.mywebsite.com", "https://www.anothersite.com/a/page.html"]

settings[:urls].each do |url|
  puts url
end
# https://www.mywebsite.com
# https://www.anothersite.com/a/page.html
# => ["https://www.mywebsite.com", "https://www.anothersite.com/a/page.html"]

settings[:dont_exist]
# => nil

a_variable = 50
settings[a_variable] = {:one => "for the money", :two => "for the show", :three => "to get ready"}
settings[50]
# => {:one=>"for the money", :two=>"for the show", :three=>"to get ready"}
settings[50][:two]
# => "for the show"

settings.save # save all current parameters to the YAML file

settings.load # load the settings from YAML file.
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

# Should we automatically load the configuration file when the class is created?
auto_load: true | false
```
If these are not specified, Confoog will use the following defaults :

```ruby
location: '~/'
filename: '.confoog'
create_file: false
prefix: 'Configuration'
quiet: false
auto_load: false
```

Confoog will set the following error constants which will be returned in the `.status['errors']` variable as needed :

```ruby
ERR_NO_ERROR = 0 # no error condition, command was succesfull
ERR_FILE_NOT_EXIST = 1 # specified configuration file does not exist
ERR_CANT_CHANGE = 2 # directory and file can only be specified through `.new()`
ERR_CANT_CREATE_FILE = 4 # cannot create the requested configuration file
ERR_NOT_WRITING_EMPTY_FILE = 8 # not attempting to save an empty configuration
ERR_CANT_SAVE_CONFIGURATION = 16 # Failed to save the configuration file
ERR_NOT_LOADING_EMPTY_FILE = 32 # not atempting to load an empty config file

INFO_FILE_CREATED = 256 # Information - specified file was created
INFO_FILE_LOADED = 512 # Information - Config file was loaded successfully
```

These are generally to do with existence and creation of configuration files.

## To Do

Thoughts in no particular order.

- Restrict configuration variables to a specified subset, or to only those that already exist in the YAML file.
- A better way of dealing with multi-level variables - i.e. nested arrays, hashes etc.
- option to save config file after any config variables are changed, not just explicitly with `Confoog::Settings.save`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests (or simply `rake`). You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

Run `rake` to run the RSpec tests, which also runs `RuboCop` and `inch --pedantic` too.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Please note - This Gem currently passes 100% on both [RuboCop][rubocop] and [Inch-CI][inch] (on pedantic mode), so all pull requests should do likewise.
Running `rake` will automatically test both these along with the RSpec tests.

[rubocop]: https://github.com/bbatsov/rubocop
[inch]: https://inch-ci.org

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

Of course, currently we have not even reached version 1, so leave off the version requirement completely. Expect any and all of the API and interface to change!

[semver]: http://semver.org/
[pvc]: http://guides.rubygems.org/patterns/#pessimistic-version-constraint

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
