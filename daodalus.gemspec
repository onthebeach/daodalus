# -*- encoding: utf-8 -*-
Gem::Specification.new do |gem|
  gem.authors       = ["Russell Dunphy"]
  gem.email         = ["russell@rsslldnphy.com"]
  gem.description   = %q{Manages connections to MongoDB.}
  gem.summary       = gem.description
  gem.homepage      = "http://github.com/rsslldnphy/daodalus"

  gem.add_runtime_dependency 'mongo', '~> 1.8.0'
  gem.add_runtime_dependency 'bson_ext', '~> 1.8.0'
  gem.add_runtime_dependency 'wendy'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'simplecov'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "daodalus"
  gem.require_paths = ["lib"]
  gem.version       = "0.0.1"
end
