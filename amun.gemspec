# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'amun/version'

Gem::Specification.new do |spec|
  spec.name          = "amun"
  spec.version       = Amun::VERSION
  spec.authors       = ["Emad Elsaid"]
  spec.email         = ["emad.elsaid.hamed@gmail.com"]

  spec.summary       = "Emacs like editor, with Ruby core instead of ELisp"
  spec.description   = "A CLI editor built to have an Emacs similar development environment, with ruby in the heart of it instead of Elisp, that will make developing plugins and extensions faster and more enjoyable, this editor is kept to the minimum, anything that could be written as an pluging will be found as a plugin."
  spec.homepage      = "http://www.github.com/blazeeboy/amun"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "curses"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-its"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "codeclimate-test-reporter", "~> 1.0.0"
end
