---
layout: default
---

# Confoog [![Gem Version](https://badge.fury.io/rb/confoog.svg)](http://badge.fury.io/rb/confoog) [![Build Status](https://travis-ci.org/seapagan/confoog.svg)](https://travis-ci.org/seapagan/confoog)


A simple Gem to add YAML configuration files to your Ruby script / Gem.

__*Note : While this Gem is fully functional, the API may be subject to changes before hitting version 1.0.0*__

This Gem allows your Ruby scripts and Gems to save and load its settings to a configuration file in YAML format.

## Installation

Add this line to your application's Gemfile:

{% highlight ruby %}
gem 'confoog'
{% endhighlight %}

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install confoog

## Usage
Currently Confoog will not allow 'nested' configuration types, however each variable can be an array or hash so multiple settings can be recorded for each variable and accessed (for a hash) by `settings[variable][hash_key]` or array using `settings[array].each`. In other words, treat the return from `settings[var]` as the type it contains. See examples below.

By default, each time a configuration variable is created or changed the file on disk will be updated with this addition or change. If you intend to make a lot of consecutive changes or do not want the small performance hit of this, pass `autosave: false` as a parameter to #new, or set it false using the #autosave accessor.

{% highlight ruby %}
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

settings.quiet = true # squelch any error or status messages to console

settings.autosave = false # disable autosave if it has been enabled with #new or #autosave

settings.save # save all current parameters to the YAML file

settings.load # load the settings from YAML file.
{% endhighlight %}

Confoog will take several parameters on creation, to specify the default config file and location. For example :

{% highlight ruby %}
settings = Confoog::Settings.new(location: '/home/myuser', filename: '.foo-settings')
{% endhighlight %}

There are other optional flags or variables that can be passed on creation:

{% highlight ruby %}
# Should a missing configuration file be created or not
create_file: true | false

# Specify an optional prefix before any error messages
prefix: 'My Application'

# Should we avoid outputting errors to the console? (ie in a GUI app)
quiet: true | false

# Should we automatically load the configuration file when the class is created?
autoload: true | false

# Should we automatically save the configuration file when a variable is created or changed?
autosave: true | false
{% endhighlight %}

If any of these are not specified, Confoog will use the following defaults :

{% highlight ruby %}
location: '~/'
filename: '.confoog'
create_file: false
prefix: 'Configuration'
quiet: false
autoload: false
autosave: true
{% endhighlight %}

Confoog will set the following error constants which will be returned in the `.status[:errors]` variable as needed :

{% highlight ruby %}
ERR_NO_ERROR = 0 # no error condition, command was succesfull
ERR_FILE_NOT_EXIST = 1 # specified configuration file does not exist
ERR_CANT_CREATE_FILE = 2 # cannot create the requested configuration file
ERR_NOT_WRITING_EMPTY_FILE = 4 # not attempting to save an empty configuration
ERR_CANT_SAVE_CONFIGURATION = 8 # Failed to save the configuration file
ERR_NOT_LOADING_EMPTY_FILE = 16 # not atempting to load an empty config file
ERR_CANT_LOAD = 32 # Cannot load configuration data from file.

INFO_FILE_CREATED = 256 # Information - specified file was created
INFO_FILE_LOADED = 512 # Information - Config file was loaded successfully
{% endhighlight %}

These are generally to do with existence and creation of configuration files.

## To Do

Thoughts in no particular order.

- Restrict configuration variables to a specified subset, or to only those that already exist in the YAML file.
- A better way of dealing with multi-level variables - i.e. nested arrays, hashes etc.
- Write standalone tests for the 'Status' class - right now it is tested at 100% by the application tests though would probably be good to have dedicated tests too
- Check Windows compatibility, certainly at least the tests will fail since there are issue with FakeFS on Window. Should be ok as a production Gem though (TBC)
- Add other file formats for storing config - XML? (Yuk!)
- Document properly on a dedicated website with full example usage and help.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests (or simply `rake`). You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

Run `rake` to run the RSpec tests, which also runs `RuboCop`, `Reek` and `inch --pedantic` too.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Please note - This Gem currently passes 100% on [RuboCop][rubocop], [Reek][reek] and [Inch-CI][inch] (on pedantic mode), so all pull requests should do likewise. Ask for guidance if needed.
Running `rake` will automatically test all 3 of those along with the RSpec tests. Note that Failures of Rubocop will cause the CI (Travis) to fail, however 'Reek' failures will not.

[rubocop]: https://github.com/bbatsov/rubocop
[reek]: https://github.com/troessner/reek
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
