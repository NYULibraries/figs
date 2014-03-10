require "figs/application"
require "figs/env"
require "figs/figsfile"
require "figs/directory_flattener"

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
    @application ||= backend.new({:file => figsfile, :stage => options[:stage]})
  end

  def load(options = {})
    application({:stage => options[:stage]}).load
  end
  
  private
  
  def figsfile
    @figsfile ||=YAML.load(ERB.new(File.read('Figsfile')).result)
  end
end
