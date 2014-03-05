module Figs
  module FileHandler
    extend self
    def directory_to_filenames files
      arr = []
      files.each {|file| Dir.exists?(file)  ? Dir.foreach(file) {|s| files << "#{file}/#{s}" unless (s =='.' || s == '..')} : arr << file if File.exists?(file)}
      arr
    end
  end
end