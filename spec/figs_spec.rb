require "spec_helper"

describe Figs do
  describe ".env" do
    let(:figsfile) { double(:figsfile) }
    let(:yaml){ YAML.load("locations: tmp/settings.yml\nmethod: path") }

    before do
      allow(Figs).to receive(:figsfile).and_return yaml
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
    let(:backend) { double(:backend, new: application) }
    let(:application) { double(:application) }
    let(:custom_application) { double(:custom_application) }
    let(:figsfile) { double(:figsfile)}
    let(:yaml){ YAML.load("locations: tmp/settings.yml\nmethod: path") }

    before do
      allow(Figs).to receive(:backend).and_return backend
      allow(Figs).to receive(:figsfile).and_return yaml
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
      allow(Figs).to receive(:application).and_return application
    end

    it "loads the application configuration" do
      expect(application).to receive(:load).once.with(no_args)

      Figs.load
    end
  end
end
