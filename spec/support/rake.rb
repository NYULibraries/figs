require "rake"

shared_context "rake", :rake => true do
  let(:rake) { Rake.application = Rake::Application.new }
  let(:name) { self.class.ancestors.map(&:description).grep(/^figaro:/).first }
  let(:task) { rake[name] }

  before do
    rake.rake_require("lib/figaro/tasks", [ROOT.to_s], [])
    Rake::Task.define_task(:environment)
  end
end
