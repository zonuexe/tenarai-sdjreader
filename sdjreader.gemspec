# -*- encoding: utf-8 -*-
require File.expand_path('../lib/sdjreader/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["USAMI Kenta"]
  gem.email         = ["tadsan@zonu.me"]
  gem.description   = "a Slashdot Japan reader (tenarai)"
  gem.summary       = ""
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "tenarai-sdjreader"
  gem.require_paths = ["lib"]
  gem.version       = Sdjreader::VERSION
end
