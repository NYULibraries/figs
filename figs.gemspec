# encoding: utf-8
$:.push File.expand_path("../lib", __FILE__)

require "figs/version"

Gem::Specification.new do |gem|
  gem.name        = "figs"
  gem.version     = "0.1.0"
  gem.version     = Figs::VERSION
  gem.platform    = Gem::Platform::RUBY

  gem.author      = "hab278"
  gem.email       = "hab278@nyu.edu"
  gem.summary     = "Simple app configuration"
  gem.description = "Simple app configuration using ENV and YAML files"
  gem.homepage    = "https://github.com/NYULibraries/figs"
  gem.license     = "MIT"

  gem.add_development_dependency "rake", "~> 10.1"
  gem.add_dependency "hashie", "~> 2.0.5"
  
  gem.executables << "figsify"
end
