require "figs/application"
require "figs/env"
require "git"

module Figs
  extend self

  attr_writer :backend, :application

  def env
    application.env
  end
  
  def backend
    @backend ||= Figs::Application
  end

  def application
    @application ||= backend.new path: figfile, environment: "staging"
  end
  
  def figfile
    fig = YAML.load(ERB.new(File.read('Figfile')).result)
    if fig["method"].eql? "git"
      return git_clone fig["location"]
    end
    return fig["location"]
  end
  
  def git_clone location
    if !File.exists?('tmp/figs/test.yml')
      Git.clone location, 'tmp/figs'
    end
    return 'tmp/figs/test.yml'
  end

  def load
    application.load
  end
end
