# -*- encoding: utf-8 -*-
Gem::Specification.new do |gem|
  gem.authors       = ["Russell Dunphy"]
  gem.email         = ["russell.dunphy@onthebeach.co.uk"]
  gem.description   = %q{Take the sting out of building complex MongoDB queries, updates and aggregations.}
  gem.summary       = gem.description
  gem.homepage      = "http://onthebeach.github.io/daodalus"

  gem.add_runtime_dependency 'id'
  gem.add_runtime_dependency 'optional'
  gem.add_runtime_dependency 'mongo'
  gem.add_runtime_dependency 'bson_ext'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'simplecov'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "daodalus"
  gem.require_paths = ["lib"]
  gem.version       = "2.0.0"
end
