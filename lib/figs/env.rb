module Figs
  module Env
    extend self
    def env
     @env ||= ::ENV
    end
    
    def soup
      @soup ||= Hash.new
    end
    
    def set(key,value)
      env[key.to_s] = value.to_s
      soup[key] = value unless key.is_a?(String) && value.is_a?(String)
    end
    
    def get(key)
      return env[key] unless soup.key?(key)
      return soup[key]
    end
  end
end
