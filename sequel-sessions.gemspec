$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'sequel-sessions'

Gem::Specification.new 'sequel-sessions', Rack::Session::Sequel::VERSION do |s|
  s.summary           = 'Sequel-based session middleware for Rack 2.0+'
  s.description       = 'Sequel-based session middleware for Rack 2.0+'
  s.authors           = ['Tom Wardrop']
  s.email             = 'tom@tomwardrop.com'
  s.homepage          = 'https://github.com/wardrop/sequel-sessions'
  s.license           = 'MIT'
  s.files             = Dir.glob(`git ls-files`.split("\n") - %w[.gitignore])
  s.test_files        = Dir.glob('spec/**/*_spec.rb')

  s.required_ruby_version = '>= 2.0.0'

  s.add_runtime_dependency "rack", '>= 2.0'
  s.add_runtime_dependency "sequel", '>= 4.0'
  s.add_development_dependency "sqlite3", '>= 1.3'
  s.add_development_dependency "minitest", '>= 5.1'
end
