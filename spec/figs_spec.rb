require "spec_helper"

describe Figs do
  describe ".env" do
    let(:figfile) { double(:figfile)}
    
    before do
      Figs.stub(:figfile) { YAML.load("location: git@github.com:NYULibraries/xCite_settings.git\nmethod: git") }
    end
    
    it "falls through to Figs::ENV" do
      expect(Figs.env).to eq(Figs::ENV)
    end
  end

  describe ".backend" do
    let(:backend) { double(:backend) }
  
    it "defaults to the Rails application backend" do
      expect(Figs.backend).to eq(Figs::Application)
    end
  
    it "is configurable" do
      expect {
        Figs.backend = backend
      }.to change {
        Figs.backend
      }.from(Figs::Application).to(backend)
    end
  end

  describe ".application" do
    let(:backend) { double(:backend) }
    let(:application) { double(:application) }
    let(:custom_application) { double(:custom_application) }
    let(:figfile) { double(:figfile)}

    before do
      Figs.stub(:backend) { backend }
      backend.stub(:new) { application }
      Figs.stub(:figfile) { YAML.load("location: git@github.com:NYULibraries/xCite_settings.git\nmethod: git") }
    end

    it "defaults to a new backend application" do
      expect(Figs.application).to eq(application)
    end

    it "is configurable" do
      expect {
        Figs.application = custom_application
      }.to change {
        Figs.application
      }.from(application).to(custom_application)
    end
  end

  describe ".load" do
    let(:application) { double(:application) }

    before do
      Figs.stub(:application) { application }
    end

    it "loads the application configuration" do
      expect(application).to receive(:load).once.with(no_args)

      Figs.load
    end
  end
end
