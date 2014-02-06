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
    @application ||= backend.new figfile
  end

  def load
    application.load
  end
  
  
  
  def figs
    Figs::ENV
  end
  
  private
  
  def figfile
    @figfile ||=YAML.load(ERB.new(File.read('Figfile')).result)
  end
  
  
end
