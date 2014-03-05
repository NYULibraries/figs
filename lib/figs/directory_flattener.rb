module Figs
  module DirectoryFlattener
    extend self
    def flattened_filenames filenames
      return filenames if !filenames.is_a?(Array)
      names = []
      filenames.each do |filename|
        Dir.exists?(filename) ? names << directory_to_filenames(filename) : names << filename
      end
      names.flatten
    end
    private
    def directory_to_filenames file
      arr = []
      Dir.exists?(file) ? Dir.foreach(file) {|s| arr << directory_to_filenames("#{file}/#{s}") unless (s =='.' || s == '..')} : arr << file if File.exists?(file)
      arr
    end
  end
end