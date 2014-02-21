require "figs/application"
require "figs/env"
require "figs/figfile"

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
    @application ||= backend.new({:file => figfile, :stage => options[:stage]})
  end

  def load(options = {})
    application({:stage => options[:stage]}).load
  end
  
  private
  
  def figfile
    @figfile ||=YAML.load(ERB.new(File.read('Figfile')).result)
  end
end
