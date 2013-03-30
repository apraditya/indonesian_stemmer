# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'indonesian_stemmer/version'

Gem::Specification.new do |gem|
  gem.name          = "indonesian_stemmer"
  gem.version       = IndonesianStemmer::VERSION
  gem.authors       = ["Adinda Praditya"]
  gem.email         = ["apraditya@gmail.com"]
  gem.description   = %q{Stems Indonesian words based on Porter Stemmer, with the algorithm presented in "A Study of Stemming Effects on Information Retrieval in Bahasa Indonesia", Fadillah Z Tala.}
  gem.summary       = %q{Porter Stemmer for Bahasa Indonesia.}
  gem.homepage      = "https://github.com/apraditya/indonesian_stemmer"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'

end
