# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'basher/version'

Gem::Specification.new do |spec|
  spec.name          = "basher"
  spec.version       = Basher::VERSION
  spec.authors       = ["shuriu"]
  spec.email         = ["stefan.rotariu@gmail.com"]

  spec.summary       = %q{Basher is a small CLI game that tests your typing speed.}
  # spec.description   = %q{TODO: Write a longer description or delete this line.}
  # spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "binding_of_caller"
  spec.add_development_dependency "pry-byebug"
  spec.add_dependency "curtis", "~> 0.1.3"
end
