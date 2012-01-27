# -*- encoding: utf-8 -*-
require File.expand_path('../lib/dlogger/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Julien Ammous"]
  gem.email         = ["schmurfy@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "dlogger"
  gem.require_paths = ["lib"]
  gem.version       = Dlogger::VERSION
  
  gem.add_development_dependency('rake')
  gem.add_development_dependency('tilt')
  gem.add_development_dependency('guard-tilt')
end
