# Simplecov::Tdd

A SimpleCov formatter for test driven development by displaying code coverage directly in the console for single files

![Example TDD](https://github.com/joshmfrankel/simplecov-tdd/blob/master/example.gif)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simplecov-tdd'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simplecov-tdd

## Usage

1. Ensure that you've configured your project to SimpleCov's _Getting Started_ section: https://github.com/colszowka/simplecov#getting-started
2. Set your SimpleCov configuration to the following:

```ruby
require "simplecov/tdd"
SimpleCov.formatter = Simplecov::Formatter::Tdd
```

Simple Setup:

```ruby
# /spec/spec_helper.rb
require "simplecov"
require "simplecov/tdd"
SimpleCov.formatter = SimpleCov::Formatter::Tdd
SimpleCov.start 'rails'
```

3. Run your tests using `rspec path/to/file_spec.rb` or `guard`
4. Fix the missing coverage
5. 💰 Profit! 💰

## Future Features

* Support for minitest

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/joshmfrankel/simplecov-tdd. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the Simplecov::Tdd project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/joshmfrankel/simplecov-tdd/blob/master/CODE_OF_CONDUCT.md).
