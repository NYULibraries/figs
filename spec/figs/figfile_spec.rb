require "spec_helper"

describe Figs::Figsfile do
  subject (:path_figsfile) { Figs::Figsfile.new("a","b","c") }
  subject (:git_figsfile) { Figs::Figsfile.new("a.git","b","c") }
  
  it { should be_a(Figs::Figsfile) }
  
  describe "#method" do
    context 'when it is a path location' do
      subject { path_figsfile.method }
      
      it { should eq("path") }
    end
    context 'when it is a git location' do
      subject { git_figsfile.method }
      
      it { should eq("git") }
    end
  end
  
  describe "#locations" do
    context 'when it is a path location' do
      subject { path_figsfile.locations }
      
      it { should be_a(Array) }
      it { should eq(["a","b","c"]) }
    end
    context 'when it is a git location' do
      subject { git_figsfile.locations }
      
      it { should be_a(Array) }
      it { should eq(["b","c"]) }
    end
  end
  
  describe "#repo" do
    context 'when it is a path location' do
      subject { path_figsfile.repo }
      it { should be(nil) }
    end
    context 'when it is a git location' do
      subject { git_figsfile.repo }
      it { should eq("a.git") }
    end
  end
  
  describe ".to_yaml" do
    context 'when it is a path location' do
      subject { path_figsfile.to_yaml }
      it { should eq(<<-YAML) }
--- !ruby/object:Figs::Figsfile
locations:
- a
- b
- c
method: path
YAML
    end
    context 'when it is a git location' do
      subject { git_figsfile.to_yaml }
      it { should eq(<<-YAML) }
--- !ruby/object:Figs::Figsfile
repo: a.git
locations:
- b
- c
method: git
YAML
    end
  end
  
  describe "#[]" do
    context 'when it is a path location' do
      subject { path_figsfile["method"] }
      it { should eq("path") }
    end
    context 'when it is a git location' do
      subject { git_figsfile["method"] }
      it { should eq("git") }
    end
  end
end