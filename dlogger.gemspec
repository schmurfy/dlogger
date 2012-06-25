# -*- encoding: utf-8 -*-
require File.expand_path('../lib/dlogger/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Julien Ammous"]
  gem.email         = ["schmurfy@gmail.com"]
  gem.description   = %q{Advanced logger allowing you to include metadata with your messages}
  gem.summary       = %q{Dynamic logger: add a context to your log messages}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "dlogger"
  gem.require_paths = ["lib"]
  gem.version       = Dlogger::VERSION
end
