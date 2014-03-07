module Figs
  class Figsfile
    attr_reader :locations, :method, :repo
    def initialize(*args)
      @repo = args.shift if args.first.downcase.end_with?(".git")
      @locations = args
      @method = @repo.nil? ? "path" : "git"
    end
    
    def [](key)
      send key
    end
  end
end