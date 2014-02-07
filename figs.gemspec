# encoding: utf-8

Gem::Specification.new do |gem|
  gem.name    = "figs"
  gem.version = "0.7.0"

  gem.author      = "Steve Richert"
  gem.email       = "steve.richert@gmail.com"
  gem.summary     = "Simple Rails app configuration"
  gem.description = "Simple, Heroku-friendly Rails app configuration using ENV and a single YAML file"
  gem.homepage    = "https://github.com/laserlemon/figaro"
  gem.license     = "MIT"

  gem.add_development_dependency "rake", "~> 10.1"

  # gem.files      = `git ls-files`.split($\)
  # gem.test_files = gem.files.grep(/^spec/)
  gem.executables << "figsify"
end
