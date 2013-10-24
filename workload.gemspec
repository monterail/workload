# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'workload/version'

Gem::Specification.new do |spec|
  spec.name          = "workload"
  spec.version       = Workload::VERSION
  spec.authors       = ["Tymon Tobolski"]
  spec.email         = ["tymon.tobolski@monterail.com"]
  spec.description   = %q{Distribute simple tasks to multiple threads with ease}
  spec.summary       = %q{Distribute simple tasks to multiple threads with ease}
  spec.homepage      = "http://github.com/monterail/workload"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
