# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'remacs/version'

Gem::Specification.new do |spec|
  spec.name          = "remacs"
  spec.version       = Remacs::VERSION
  spec.authors       = ["Emad Elsaid"]
  spec.email         = ["blazeeboy@gmail.com"]

  spec.summary       = "Emacs like editor, with Ruby core instead of ELisp"
  spec.description   = "A CLI editor built to have an Emacs similar development environment, with ruby in the heart of it instead of Elisp, that will make developing plugins and extensions faster and more enjoyable, this editor is kept to the minimum, anything that could be written as an pluging will be found as a plugin."
  spec.homepage      = "http://www.github.com/blazeeboy/remacs"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "curses", "~> 1.2"
  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-minitest"
end
