# Simplecov::Tdd

A SimpleCov formatter for test driven development. Displays code coverage results in the console for single files

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
# OR use multi-formatter
SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  Simplecov::Formatter::Tdd
])
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

## Configuration options

There are a few configuration options that may be set before formatting is called.
Generally you may place these after `SimpleCov.formatter` or `SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new` in your setup.

### output_style (default: :simple)
When there are lines missing coverage, this option determines how to display output.
The accepted values are `:simple` (default) or `:verbose`.

```ruby
SimpleCov::Formatter::Tdd.output_style = :verbose
```

Here's an example of what :verbose output looks like:

```ruby
app/models/matched_90.rb
90.0% coverage, 167 total lines

The following 2 lines have missing coverage:
[5, 25]

line | source code
-------------------
5 => obj.is_a?(SomeClass)
25 => SomeClass.explode!
```

### debug_mode (default: false)
This is useful for determining if the current file being tested doesn't have
a match from SimpleCov's file list.

```ruby
SimpleCov::Formatter::Tdd.debug_mode = true
```

## Future Features

* Support for minitest

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/joshmfrankel/simplecov-tdd. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the Simplecov::Tdd project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/joshmfrankel/simplecov-tdd/blob/master/CODE_OF_CONDUCT.md).
