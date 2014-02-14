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
    
    def delete(key)
      env.delete(key) {nil}
      if env_objects.key?(key)
        env_objects.delete(key) {nil}
      end
    end
    
    def []key
      return env_objects[key] if env_objects.key?(key)
      return env[key]
    end
    
    def []=(key,value)
      set(key, value)
    end
    
    def update
      env_objects.keys.each {|key| env.key?(key)
    end
    
    
    def method_missing(meth, *args, &block)
      # Check to see if it can be evaluated
      if(matches_key? meth)
        key, value = env.detect { |k, v| k.upcase.eql?(meth.to_s.upcase) }
        return self[key]
      elsif(boolean_method? meth)
        matches_key?(meth.to_s.chop!)
      elsif(bang_method? meth)
        send(meth.to_s.chop!)
      elsif(setter_method?(meth))
        set(meth.to_s.chop!, args.first)
      else
        super
      end
    end
    
    def respond_to? meth
      if bang_method?(meth)
        return matches_key?(meth.to_s.chop!)
      end
      setter_method?(meth) || boolean_method?(meth) || matches_env?(meth)  || matches_key?(meth) || super
    end
    
    def boolean_method? meth
      meth.to_s.end_with? '?'
    end
    
    def bang_method? meth
      meth.to_s.end_with?('!')
    end
    
    def setter_method? meth
      meth.to_s.end_with?('=')
    end
    
    def matches_env? meth
      env.respond_to?(meth)
    end
    
    def matches_env_objects? meth
      @env_objects.respond_to?(meth)
    end
    
    def matches_key? meth
      env.keys.any? {|key| key.upcase.eql?(meth.to_s.upcase) }
    end
  end
end
