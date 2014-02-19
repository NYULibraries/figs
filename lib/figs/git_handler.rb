require "git"

module Figs
  module GitHandler
    extend self
    TMP_GIT_DIR = "tmp/figs/"

    def location gitpath, filenames
      git_clone gitpath
      tmp_filenames(([]<<filenames).flatten)
    rescue
      clear_tmp_dir
    end
    
    private
    
    def tmp_filenames filenames
      tmp_files = []
      filenames.each { |filename| tmp_files << copy_to_tmp_files(filename) }
      clear_tmp_dir
      tmp_files
    end
    
    def copy_to_tmp_files filename
      Tempfile.open("#{filename}") do |file|
        file.write(File.open("#{TMP_GIT_DIR}#{filename}").read)
        file.path
      end
    end
    
    def git_clone gitpath
      clear_tmp_dir
      ::Git.clone gitpath, TMP_GIT_DIR
    end
    
    def clear_tmp_dir
      FileUtils.rm_rf TMP_GIT_DIR
    end
  end
end
