# Confoog [![Gem Version](https://badge.fury.io/rb/confoog.svg)](http://badge.fury.io/rb/confoog) [![Build Status](https://travis-ci.org/seapagan/confoog.svg)](https://travis-ci.org/seapagan/confoog)

[![Dependency Status](https://gemnasium.com/seapagan/confoog.svg)](https://gemnasium.com/seapagan/confoog)
[![Coverage Status](https://coveralls.io/repos/seapagan/confoog/badge.svg?branch=master&service=github)](https://coveralls.io/github/seapagan/confoog?branch=master)
[![Code Climate](https://codeclimate.com/github/seapagan/confoog/badges/gpa.svg)](https://codeclimate.com/github/seapagan/confoog)
[![Inline docs](http://inch-ci.org/github/seapagan/confoog.svg?branch=master)](http://inch-ci.org/github/seapagan/confoog)
[![PullReview stats](https://www.pullreview.com/github/seapagan/confoog/badges/master.svg?)](https://www.pullreview.com/github/seapagan/confoog/reviews/master)

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
Very basic usage is as below. For full documentation, see the [Confoog Web Site][confoog]

[confoog]: http://confoog.seapagan.net

```ruby
require 'confoog'

settings = Confoog::Settings.new
settings[:var] = value
settings[:array] = [1, 2, 3, 4]
settings[42] = "Meaning of life"
settings[:urls] = ["https://www.mywebsite.com", "https://www.anothersite.com/a/page.html"]
```

## To Do

Thoughts in no particular order.

- Restrict configuration variables to a specified subset, or to only those that already exist in the YAML file.
- A better way of dealing with multi-level variables - i.e. nested arrays, hashes etc.
- Write standalone tests for the 'Status' class - right now it is tested at 100% by the application tests though would probably be good to have dedicated tests too
- Check Windows compatibility, certainly at least the tests will fail since there are issue with FakeFS on Window. Should be ok as a production Gem though (TBC)
- Add other file formats for storing config - XML? (Yuk!)
- Document properly on a dedicated website with full example usage and help.
- Add an option to use a config file stored in the script directory, if existing, instead of the specified one. Will make developing of Gems and Apps using this a bit easier.
- Add ability to generate custom error messages (eg if the config file is missing and similar)
- Add 'transient' options that will not be saved to the YAML file. This allows Confoog to be used for temp variable storage also without making them permanent.

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
