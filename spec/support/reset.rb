RSpec.configure do |config|
  config.before do
    Fig.backend = nil
    Fig.application = nil
  end
end
