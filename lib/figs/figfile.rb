module Figs
  class Figfile
    attr_reader :locations, :method, :repo
    def initialize(*args)
      @repo = args.shift if args.first.downcase.end_with?(".git")
      @locations = args
      @method = @repo.nil? ? "path" : "git"
    end
  end
end