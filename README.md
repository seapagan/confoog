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
There are other optional flags or variables that can be passed on creation. If not specified these will default to false:
```ruby
# Should a missing configuration file be created or not
create_file: true | false
```
If these are not specified, Confoog will use the following defaults :
```ruby
location: '~/'
filename: '.confoog'
create_file: false
```

## To Do

Thoughts in no particular order
- add a status / error variable to the class for use by callers and a set of standard error constants.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests (or simply `rake`). You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/seapagan/confoog.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
