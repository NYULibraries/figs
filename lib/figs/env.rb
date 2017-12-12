require 'date'
require 'time'
module Figs
  module ENV
    extend self

    def env
     @env ||= ::ENV
    end

    # Since Ruby's implementation of YAML has a set of "basic types" that are
    # implicitly converted from String to the appropriate type, we convert the
    # "basic types" to strings (appropriately) and store them in ENV, so that
    # a Figs application can just call ENV['VAR_NAME'] for "basic types"
    # Basic Types handled are
    #   - Integer
    #   - Float
    #   - Null
    #   - Boolean
    #   - Time (in the ISO8601 format)
    #   - Date (in the ISO8601 format)
    def set(key,value)
      env[key.to_s] = begin
        case value
        when String
          value
        when Integer, Float
          value.to_s
        when FalseClass, TrueClass
          value.to_s
        when Time, Date
          value.iso8601
        when NilClass
          '~'
        else
          YAML::dump(value)
        end
      end
    end

    def [](key)
      return demarshall(env[key.to_s])
    end

    def []=(key,value)
      set(key, value)
    end

    def demarshall(value)
      value.nil? ? nil : YAML::load(value)
    end

    def method_missing(method, *args, &block)
      if matches_env?(method) then return env.send(method, *args, &block) end

      key, punctuation = extract_key_from_method(method)
      _, value = env.detect { |k, _| k.upcase == key }

      value = demarshall(value)

      case punctuation
      when "!" then value || missing_key!(key)
      when "?" then !!value
      when nil then value
      else super
      end
    end

    def extract_key_from_method(method)
      method.to_s.upcase.match(/^(.+?)([!?=])?$/).captures
    end

    def missing_key!(key)
      raise MissingKey.new("Missing required Figaro configuration key #{key.inspect}.")
    end

    def respond_to?(method, *)
      return true if matches_env?(method)
      key, punctuation = extract_key_from_method(method)

      case punctuation
      when "!" then env.keys.any? { |k| k.upcase == key } || super
      when "?", nil then true
      else super
      end
    end

    def matches_env?(method)
      env.respond_to?(method)
    end
  end
end
