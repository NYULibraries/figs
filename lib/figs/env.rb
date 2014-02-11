require 'hashie'
module Figs
  module ENV
    extend self
    
    class EnvObjects < Hash
      include Hashie::Extensions::MethodAccess
    end
    
    def env
     @env ||= ::ENV
    end
    
    def env_objects
      @env_objects ||= EnvObjects.new
    end
    
    def set(key,value)
      env[key.to_s] = value.to_s
      env_objects[key] = value unless key.is_a?(String) && value.is_a?(String)
    end
    
    def []key
      return env_objects[key] if env_objects.key?(key)
      return env[key]
    end
    
    def []=(key,value)
      set(key, value)
    end
    
    def method_missing(meth, *args, &block)
      # Check to see if it can be evaluated
      if(matches_env? meth)
        env.send meth, *args, &block
      elsif(matches_env_key? meth)
        key, value = env.detect { |k, v| k.upcase.eql?(meth.to_s.upcase) }
        return value
      elsif(matches_env_objects? meth)
        @env_objects.send meth, *args, &block
      else
        super
      end
    end
    
    def respond_to? meth
      matches_env?(meth) || matches_env_objects?(meth) || matches_env_key?(meth)
    end
    
    def matches_env? meth
      env.respond_to?(meth)
    end
    
    def matches_env_key? meth
      env.keys.any? {|key| key.upcase.eql?(meth.to_s.upcase) }
    end
    
    def matches_env_objects? meth
      @env_objects.respond_to? meth
    end
  end
end
