require "rake"

shared_context "rake", :rake => true do
  let(:rake) { Rake.application = Rake::Application.new }
  let(:name) do
    example.example_group.parent_groups.detect { |group|
      group.description =~ /^figaro:/
    }.description
  end
  let(:task) { rake[name] }

  before do
    rake.rake_require("lib/figaro/tasks", [ROOT.to_s], [])
    Rake::Task.define_task(:environment)
  end
end
