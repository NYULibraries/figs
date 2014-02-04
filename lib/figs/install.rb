require "erb"
require "yaml"

require "figs/error"
require 'rake'



module Figs
  class Install < Rake::Application
    
    def initialize
      super
      
      @name = "figs"
      @rakefiles = [File.expand_path(File.join(File.dirname(__FILE__),'tasks/install.rake'))]
    end
    
    def run
      Rake.application = self
      super
    end
  end
end
