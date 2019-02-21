
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "simplecov/tdd/version"

Gem::Specification.new do |spec|
  spec.name          = "simplecov-tdd"
  spec.version       = SimpleCov::Tdd::VERSION
  spec.authors       = ["Josh Frankel"]
  spec.email         = ["joshmfrankel@gmail.com"]

  spec.summary       = "SimpleCov formatter for test driven development"
  spec.description   = "SimpleCov formatter for test driven development"
  spec.homepage      = "https://github.com/joshmfrankel/simplecov-tdd"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.add_dependency "simplecov", ">= 0"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry", ">= 0"
end
