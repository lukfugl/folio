# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'parchment/version'

Gem::Specification.new do |spec|
  spec.name          = "parchment"
  spec.version       = Parchment::VERSION
  spec.authors       = ["Jacob Fugal"]
  spec.email         = ["jacob@instructure.com"]
  spec.description   = %q{A pagination library.}
  spec.summary       = %q{
    Parchment is a library for pagination. It's meant to be nearly compatible
    with WillPaginate, but with broader -- yet more well-defined -- semantics
    to allow for sources whose page identifiers are non-ordinal.
  }
  spec.homepage      = "https://github.com/instructure/parchment"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
