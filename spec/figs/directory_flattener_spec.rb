require "spec_helper"

describe Figs::DirectoryFlattener do
  subject (:directoryflattener) { Figs::DirectoryFlattener.flattened_filenames(["spec"]) }
  
  describe "#flattened_filenames" do
    context "directories" do
      subject { directoryflattener } 
      # it { should eq(["spec/figs/application_spec.rb", "spec/figs/directory_flattener_spec.rb", "spec/figs/env_spec.rb", "spec/figs/figfile_spec.rb", "spec/figs_spec.rb", "spec/spec_helper.rb", "spec/support/aruba.rb", "spec/support/random.rb", "spec/support/reset.rb"]) }
    end
  end
end