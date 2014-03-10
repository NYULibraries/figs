require "spec_helper"

SPEC_TMP_DIR = "tmp/flattener"

describe Figs::DirectoryFlattener do
  def create_tmp_dir
    FileUtils.mkdir_p("#{SPEC_TMP_DIR}")
    FileUtils.mkdir_p("#{SPEC_TMP_DIR}/#{SPEC_TMP_DIR}")
    File.open("#{SPEC_TMP_DIR}/#{SPEC_TMP_DIR}/config.yml", File::WRONLY|File::CREAT)
    File.open("#{SPEC_TMP_DIR}/#{SPEC_TMP_DIR}/config2.yml", File::WRONLY|File::CREAT)
    File.open("#{SPEC_TMP_DIR}/config.yml", File::WRONLY|File::CREAT)
    File.open("#{SPEC_TMP_DIR}/config2.yml", File::WRONLY|File::CREAT)
  end
  
  before(:each) do
    create_tmp_dir
  end
  subject (:directoryflattener) { Figs::DirectoryFlattener.flattened_filenames([SPEC_TMP_DIR]) }
  
  describe "#flattened_filenames" do
    context "directories" do
      subject { directoryflattener } 
      it { should eq(["tmp/flattener/config.yml", "tmp/flattener/config2.yml", "tmp/flattener/tmp/flattener/config.yml", "tmp/flattener/tmp/flattener/config2.yml"]) }
    end
  end
end