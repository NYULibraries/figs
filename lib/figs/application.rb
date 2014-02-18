require "erb"
require "yaml"

require "figs/error"
require "figs/env"
require "figs/git"

module Figs
  class Application
    FIG_ENV_PREFIX = "_FIG_"

    include Enumerable

    attr_writer :stage, :path

    def initialize(options = {})
      @figfile = options[:file]
      @stage = options[:stage]
      load_path
    end
    
    def load_path
      if figfile["method"].eql? "git"
        @path = Figs::Git.location(figfile["location"], @stage)
      else
        @path = figfile["location"]
      end
    end
    
    def figfile
      (@figfile || default_figfile)
    end

    def path
      (@path || default_path).to_s
    end

    def stage
      (@stage || default_stage).to_s
    end

    def configuration
      global_configuration.merge(stage_configuration)
    end

    def load
      each do |key, value|
        set(key, value) unless skip?(key)
      end
      Figs::Git.delete_after_loading
    end
    
    def env
      Figs::ENV
    end

    def each(&block)
      configuration.each(&block)
    end

    private

    def default_path
      raise NotImplementedError
    end

    def default_stage
      raise NotImplementedError
    end
    
    def default_figfile
      raise NotImplementedError
    end

    def raw_configuration
      (@parsed ||= Hash.new { |hash, path| hash[path] = parse(path) })[path]
    end

    def parse(path)
      File.exist?(path) && YAML.load(ERB.new(File.read(path)).result) || {}
    end

    def global_configuration
      raw_configuration
    end

    def stage_configuration
      raw_configuration.fetch(stage) { {} }
    end

    def set(key, value)
      # FigsFigs::ENV.set_array(key, value) unless !value.is_a?(Array)
      Figs::ENV[key] = value
      Figs::ENV[FIG_ENV_PREFIX + key.to_s] = value
    end

    def skip?(key)
      Figs::ENV.key?(key.to_s) && !Figs::ENV.key?(FIG_ENV_PREFIX + key.to_s)
    end

    def non_string_configuration!(value)
        warn "WARNING: Use strings for Fig configuration. #{value.inspect} was converted to #{value.to_s.inspect}."
    end
  end
end
