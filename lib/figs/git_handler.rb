require "git"

module Figs
  module GitHandler
    extend self
    TMP_GIT_DIR = "tmp/figs/"

    def location(gitpath, filenames)
      @temp_files = []
      git_clone gitpath
      temp_filenames(([]<< filenames).flatten)
    rescue Exception => e
      p e
      clear_tmp_dir
      clear_temp_files
    end
    
    def clear_temp_files
      return unless !@temp_files.nil?
      @temp_files.each { |temp_file| temp_file.close temp_file.unlink }
    end
    
    private
    
    def temp_filenames(filenames)
      temp_files = []
      filenames.each { |filename| temp_files << copy_to_temp_files(filename) }
      clear_tmp_dir
      temp_files
    end
    
    def copy_to_temp_files(filename)
      temp_file = Tempfile.new("#{filename.gsub('/','-')}")
      temp_file.open
      temp_file.write(File.open("#{TMP_GIT_DIR}#{filename}").read)
      temp_file.flush
      @temp_files << temp_file
      temp_file.path
    end
    
    def git_clone(gitpath)
      clear_tmp_dir
      ::Git.clone gitpath, TMP_GIT_DIR
    end
    
    def clear_tmp_dir
      FileUtils.rm_rf TMP_GIT_DIR
    end
  end
end
