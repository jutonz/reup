# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'reup/version'

Gem::Specification.new do |spec|
  spec.name          = "reup"
  spec.version       = Reup::VERSION
  spec.authors       = ["Justin Toniazzo"]
  spec.email         = ["jutonz42@gmail.com"]

  spec.summary       = "A simple tool for updating local git repositories."
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/jutonz/reup"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "cocaine", "~> 0.5.7"
  spec.add_dependency "slop", "~> 4.2.0"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "byebug"
end
