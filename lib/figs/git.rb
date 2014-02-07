require "git"

module Figs
  module Git
    extend self
    TMP_GIT_DIR = "tmp/figs/"
    def location path, filename
      clone_dir path, filename
      "#{TMP_GIT_DIR}#{filename}.yml"
    end
    
    def clone_dir path, filename
      if !File.exists?("#{TMP_GIT_DIR}#{filename}.yml")
        ::Git.clone path, TMP_GIT_DIR
      end
    end

    def delete_after_loading
      FileUtils.rm_rf TMP_GIT_DIR
    end
  end
end
