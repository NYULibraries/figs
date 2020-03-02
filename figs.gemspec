# encoding: utf-8
$:.push File.expand_path("../lib", __FILE__)

require "figs/version"

Gem::Specification.new do |gem|
  gem.name        = "figs"
  gem.version     = Figs::VERSION
  gem.platform    = Gem::Platform::RUBY

  gem.author      = "hab278"
  gem.email       = "hab278@nyu.edu"
  gem.summary     = "Simple app configuration"
  gem.description = "Simple app configuration using ENV and YAML files"
  gem.homepage    = "https://github.com/NYULibraries/figs"
  gem.license     = "MIT"

  gem.files       = Dir["{app,lib,config,bin}/**/*"] + ["Rakefile", "Gemfile", "README.md"]

  gem.add_dependency "rake", ">= 10.5", "< 14.0"
  gem.add_dependency "git", "~> 1.2"

  gem.add_development_dependency "coveralls", "~> 0.7"
  gem.add_development_dependency "rspec", "~> 3.5"

  gem.executables << "figsify"
end
