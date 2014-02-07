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

  def application(options = {})
    @application ||= backend.new({:file => figfile, :environment => options[:environment]})
  end

  def load(options = {})
    application({:environment => options[:environment]}).load
  end
  
  private
  
  def figfile
    @figfile ||=YAML.load(ERB.new(File.read('Figfile')).result)
  end
end
