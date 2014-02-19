require "erb"
require "yaml"

require "figs/error"
require "figs/env"
require "figs/git_handler"

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
        @path = path_from_git figfile["location"]
      else
        @path = figfile["location"]
      end
    end
    
    def path_from_git locations
      if(locations.is_a?(Array))
        Figs::GitHandler.location(locations.first, locations.last(locations.size-1))
      else
        Figs::GitHandler.location(location, @stage)
      end
    end
    
    def figfile
      (@figfile || default_figfile)
    end

    def path
      (@path || default_path)
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

    def parse_path(path)
      File.exist?(path) && YAML.load(ERB.new(File.read(path)).result) || {}
    end
    
    def parse(paths)
      parse = {}
      paths.is_a?(Array) ? paths.each { |path| parse.merge!(parse_path(path)) } : parse.merge!(parse_path(paths))
      parse
    end

    def global_configuration
      raw_configuration.reject { |key, value| key.to_s.eql?(stage) && value.is_a?(Hash) }
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
