# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gembox/version'

Gem::Specification.new do |gem|
  gem.name          = "gembox"
  gem.version       = Gembox::VERSION
  gem.authors       = ["Robert Roach"]
  gem.email         = ["rjayroach@gmail.com"]
  gem.description   = %q{A gem server}
  gem.summary       = %q{Host a public and private Gem server}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
