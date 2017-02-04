# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ever2boost/version'

Gem::Specification.new do |spec|
  spec.name          = 'ever2boost'
  spec.version       = Ever2boost::VERSION
  spec.authors       = ['asmsuechan']
  spec.email         = ['suenagaryoutaabc@gmail.com']

  spec.summary       = 'Convert Evernote to Boostnote'
  spec.description   = 'ever2boost converts the all of your notes in Evernote into Boostnote'
  spec.homepage      = 'https://github.com/BoostIO/ever2boost'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'evernote-thrift'
  spec.add_dependency 'thor'

  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
