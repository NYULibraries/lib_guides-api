lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lib_guides/version'

Gem::Specification.new do |s|
  s.name        = 'lib_guides-api'
  s.version     = LibGuides::VERSION
  s.date        = '2016-05-26'
  s.summary     = "Ruby client for LibGuides API"
  s.description = "Ruby client for LibGuides API"
  s.authors     = ["Eric Griffis"]
  s.email       = 'eric.griffis@nyu.edu'

  s.files         = `git ls-files`.split($/)
  s.test_files    = %w[spec/lib/lib_guides/api/base_spec.rb spec/lib/lib_guides/api/component_spec.rb spec/lib/lib_guides/api/component_list_spec.rb]
  s.require_paths = ["lib"]

  s.homepage    = 'https://github.com/NYULibraries/lib_guides'
  s.license     = 'MIT'

  s.add_dependency 'faraday', '>= 0.11'
  s.add_dependency 'json'

  s.add_development_dependency 'pry'
end
