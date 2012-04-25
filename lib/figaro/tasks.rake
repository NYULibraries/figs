namespace :figaro do
  desc "Configure Heroku according to application.yml"
  task :heroku, [:app] => :environment do |_, args|
    Figaro::Tasks.heroku(args[:app])
  end

  desc "Configure Travis according to application.yml"
  task :travis, [:vars] => :environment do
  end
end
