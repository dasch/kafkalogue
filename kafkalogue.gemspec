# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kafkalogue/version'

Gem::Specification.new do |spec|
  spec.name          = "kafkalogue"
  spec.version       = Kafkalogue::VERSION
  spec.authors       = ["Daniel Schierbeck"]
  spec.email         = ["dasch@zendesk.com"]

  spec.summary       = %q{A buffered log backed by Apache Kafka}
  spec.description   = %q{A buffered log backed by Apache Kafka.}
  spec.homepage      = "https://github.com/dasch/kafkalogue"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "poseidon", "~> 0.0.5"
  spec.add_dependency "snappy", "~> 0.0.12"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "dotenv"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "activesupport"
end
