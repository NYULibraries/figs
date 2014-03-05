require "spec_helper"

describe Figs::FileHandler do
  subject (:filehander) { Figs::FileHandler }
  
  describe "#directory_to_filenames" do
    context "directories" do
      subject { filehander.directory_to_filenames(["spec"])} 
      it { should eq("git") }
    end
  end
end