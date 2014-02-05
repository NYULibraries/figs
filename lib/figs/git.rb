require "git"

module Figs
  module Git
    extend self
    TMP_GIT_DIR = "tmp/figs/"
    def location path
      clone_dir path
      "#{TMP_GIT_DIR}application.yml"
    end
    
    def clone_dir path
      if !File.exists?("#{TMP_GIT_DIR}application.yml")
        ::Git.clone path, TMP_GIT_DIR
      end
    end

    def delete_after_loading
      FileUtils.rm_rf TMP_GIT_DIR
    end
  end
end
