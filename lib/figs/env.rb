module Figs
  module ENV
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
    
    def []key
      return soup[key] if soup.key?(key)
      return env[key]
    end
    
    def []=(key,value)
      set(key, value)
    end
    
    def method_missing(meth, *args, &block)
      # Check to see if it can be evaluated
      if(matches? meth)
        env.send meth, *args, &block
      else
        super
      end
    end
    
    def respond_to? meth
      matches? meth
    end
    
    def matches? meth
      env.respond_to? meth
    end
  end
end
