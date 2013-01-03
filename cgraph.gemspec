# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ["Martin Schneider"]
  gem.email         = ["martin.schneider@pludoni.de"]
  gem.description   = %q{}
  gem.summary       = %q{}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "cgraph"
  gem.require_paths = ["lib"]
  gem.version       = "0.0.4"
  gem.add_development_dependency "guard-minitest"
  gem.add_development_dependency "minitest"

  gem.add_dependency "ruby-graphviz"
end
