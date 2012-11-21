# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'on/version'

Gem::Specification.new do |gem|
  gem.name          = "on"
  gem.version       = On::VERSION
  gem.authors       = ["Peter Suschlik"]
  gem.email         = ["ps@neopoly.de"]
  gem.description   = %q{Dynamic callbacks with ruby blocks.}
  gem.summary       = %q{}
  gem.homepage      = "https://github.com/neopoly/on"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rdoc'

  gem.add_development_dependency 'minitest'
  gem.add_development_dependency 'testem'
end
