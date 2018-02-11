# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "zaif_wrapper/version"

Gem::Specification.new do |spec|
  spec.name          = "zaif_wrapper"
  spec.version       = ZaifWrapper::VERSION
  spec.authors       = ["cobafan"]
  spec.email         = ["akitaka0405@gmail.com"]

  spec.summary       = %q{Zaif Api Library}
  spec.description   = %q{I made this so that We can easily use Zaif's API}
  spec.homepage      = "https://github.com/cobafan/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'rest-client'
  spec.add_runtime_dependency 'json'
  spec.add_runtime_dependency 'websocket-client-simple'

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
end
