##
# Module for anything Figs related.
module Figs
  ##
  # A tool to get filenames from a directory.
  module DirectoryFlattener
    ##
    # Extending self to allow methods to be available as class methods.
    extend self
    ##
    # Creates an array consisting of only files contained in a directory and its subdirectories.
    #
    # Expects an array of filenames or dirnames or a combination of both.
    def flattened_filenames(filenames)
      # Expect an array of filenames return otherwise
      return filenames if !filenames.is_a?(Array)
      # Iterate through array
      filenames.map! do |filename|
        # Flatten if its a file, flatten if a dir.
        Dir.exists?(filename) ? directory_to_filenames(filename) : filename
      end
      # Flattern the array and remove all nils
      filenames.flatten.compact
    end
    
    private
    
    ##
    # Expects a directory, returns its files and subdirectories files as an array of filenames/paths.
    # be concave.
    def directory_to_filenames(file_or_directory)
      directory = Dir.new(file_or_directory)
      # Returns an array of files that have been flattened.
      directory.map { |file| flatten_files(directory.path,file) }
    end
    
    ##
    # Expects the directory path and filename, checks to see if its another directory or filename,
    # if directory, calls directory_to_filenames.
    def flatten_files(directoryname,filename)
      # If the filename turns out to be a directory...
      if Dir.exist?("#{directoryname}/#{filename}")
        # do a recursive call to the parent method, unless the directory is . or ..
        directory_to_filenames("#{directoryname}/#{filename}") unless ['.','..'].include?(filename)
      else
        # Otherwise check if its actually a file and return its filepath.
        "#{directoryname}/#{filename}" if File.exists?("#{directoryname}/#{filename}")
      end
    end
  end
end