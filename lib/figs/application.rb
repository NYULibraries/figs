require "erb"
require "yaml"

require "figs/error"
require "figs/env"

module Figs
  class Application
    FIG_ENV_PREFIX = "_FIG_"

    include Enumerable

    attr_writer :path, :environment

    def initialize(options = {})
      @path = options[:path]
      @environment = options[:environment]
    end

    def path
      (@path || default_path).to_s
    end

    def environment
      (@environment || default_environment).to_s
    end

    def configuration
      global_configuration.merge(environment_configuration)
    end

    def load
      each do |key, value|
        set(key, value) unless skip?(key)
      end
    end
    
    def env
      
      ::ENV
    end

    def each(&block)
      configuration.each(&block)
    end

    private

    def default_path
      raise NotImplementedError
    end

    def default_environment
      raise NotImplementedError
    end

    def raw_configuration
      (@parsed ||= Hash.new { |hash, path| hash[path] = parse(path) })[path]
    end

    def parse(path)
      File.exist?(path) && YAML.load(ERB.new(File.read(path)).result) || {}
    end

    def global_configuration
      raw_configuration.reject { |_, value| value.is_a?(Hash) }
    end

    def environment_configuration
      raw_configuration.fetch(environment) { {} }
    end

    def set(key, value)
      non_string_configuration!(key) unless key.is_a?(String)
      non_string_configuration!(value) unless value.is_a?(String)
      
      # Figs::ENV.set_array(key, value) unless !value.is_a?(Array)
      ::ENV[key.to_s] = value.to_s
      ::ENV[FIG_ENV_PREFIX + key.to_s] = value.to_s
    end

    def skip?(key)
      ::ENV.key?(key.to_s) && ::ENV.key?(FIG_ENV_PREFIX + key.to_s)
    end

    def non_string_configuration!(value)
        warn "WARNING: Use strings for Fig configuration. #{value.inspect} was converted to #{value.to_s.inspect}."
    end
  end
end
