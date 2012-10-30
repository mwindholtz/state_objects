# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'state_objects/version'

Gem::Specification.new do |gem|
  gem.name          = "state_objects"
  gem.version       = StateObjects::VERSION
  gem.authors       = ["Mark Windholtz"]
  gem.email         = ["windholtz@gmail.com"]
  gem.homepage      = "https://github.com/mwindholtz/state_objects"
  gem.summary       = %q{ 'State' Design Pattern from the Gang of Four book }
  gem.description   = %q{ 'State' Design Pattern from the Gang of Four book }

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]            
  
  # gem.add_development_dependency "supermodel" # TODO  
  # gem.add_development_dependency "activerecord"
  gem.add_development_dependency "supermodel"
  gem.add_development_dependency "rspec-given"
  gem.add_runtime_dependency     "activerecord"
  
end
