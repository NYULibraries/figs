require "spec_helper"

describe Figs::Figfile do
  subject (:path_figfile) { Figs::Figfile.new("a","b","c") }
  subject (:git_figfile) { Figs::Figfile.new("a.git","b","c") }
  
  it { should be_a(Figs::Figfile) }
  
  describe "#method" do
    context 'when it is a path location' do
      subject { path_figfile.method }
      
      it { should eq("path") }
    end
    context 'when it is a git location' do
      subject { git_figfile.method }
      
      it { should eq("git") }
    end
  end
  
  describe "#locations" do
    context 'when it is a path location' do
      subject { path_figfile.locations }
      
      it { should be_a(Array) }
      it { should eq(["a","b","c"]) }
    end
    context 'when it is a git location' do
      subject { git_figfile.locations }
      
      it { should be_a(Array) }
      it { should eq(["b","c"]) }
    end
  end
  
  describe "#repo" do
    context 'when it is a path location' do
      subject { path_figfile.repo }
      it { should be(nil) }
    end
    context 'when it is a git location' do
      subject { git_figfile.repo }
      it { should eq("a.git") }
    end
  end
  
  describe ".to_yaml" do
    context 'when it is a path location' do
      subject { path_figfile.to_yaml }
      it { should eq(<<-YAML) }
--- !ruby/object:Figs::Figfile
locations:
- a
- b
- c
method: path
YAML
    end
    context 'when it is a git location' do
      subject { git_figfile.to_yaml }
      it { should eq(<<-YAML) }
--- !ruby/object:Figs::Figfile
repo: a.git
locations:
- b
- c
method: git
YAML
    end
  end
end