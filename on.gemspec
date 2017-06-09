# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'on/version'

Gem::Specification.new do |gem|
  gem.name          = "on"
  gem.version       = On::VERSION
  gem.authors       = ["Peter Leitzen"]
  gem.email         = ["pl@neopoly.de"]
  gem.description   = %q{Dynamic callbacks with Ruby blocks.}
  gem.summary       = %q{Inspired by http://www.mattsears.com/articles/2011/11/27/ruby-blocks-as-dynamic-callbacks}
  gem.homepage      = "https://github.com/neopoly/on"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rdoc'

  gem.add_development_dependency 'minitest'
end
