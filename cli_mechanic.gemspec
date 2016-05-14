# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cli_mechanic/version'

Gem::Specification.new do |spec|
  spec.name          = "cli_mechanic"
  spec.version       = CliMechanic::VERSION
  spec.authors       = ["James Short"]
  spec.email         = ["james.short@alumni.duke.edu"]
  spec.description   = %q{Ruby CLI option and argument parser}
  spec.summary       = %q{Ruby option and argument parser for CLI tools using simple yaml configuration}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake', '~> 11.1', '>= 11.1.2'
  spec.add_development_dependency 'rspec', '~> 3.2', '>= 3.2.0'
end
