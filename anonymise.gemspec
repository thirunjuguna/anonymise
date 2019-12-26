# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'anonymise/version'

Gem::Specification.new do |spec|
  spec.name          = 'anonymise'
  spec.version       = Anonymise::VERSION
  spec.authors       = ['Thiru Njuguna']
  spec.email         = ['thirunjuguna@outlook.com']

  spec.summary       = 'anonymise'
  spec.description   = 'Anonymise helps you fake your postgres database'
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = ['anonymise']
  spec.require_paths = ['lib']

  spec.homepage      = 'http://github.com/thirunjuguna/anonymise'
  spec.license       = 'MIT'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage

  spec.add_runtime_dependency('colorize', '0.8.1')
  spec.add_runtime_dependency 'thor', '1.0.1'
  spec.add_runtime_dependency 'faker', '2.9.0'
  spec.add_runtime_dependency 'pg', '1.1.4'
  spec.add_runtime_dependency 'bundler', '~> 2.1.2'

  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
