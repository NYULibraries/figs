require "figs/application"
require "figs/env"

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
    @application ||= backend.new path: File.read('Figfile'), environment: "staging"
  end

  def load
    application.load
  end
end
