RSpec.configure do |config|
  config.before do
    Figs.backend = nil
    Figs.application = nil
  end
end
