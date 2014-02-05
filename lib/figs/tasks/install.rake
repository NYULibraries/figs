require 'erb'
require 'pathname'
desc 'Install Fig'
task :install, :location, :method, :remote do |task, args|
  base_dir = Pathname.new('.')
  
  location = args[:location] || "application.yml"
  method = args[:method] || "path"
  file = base_dir.join('Figfile')
  File.open(file, 'w+') do |f|
    f.write("location: #{location}\nmethod: #{method}")
  end
  
  if !File.exists?(location) && method.eql?("path")
    application_yml = File.expand_path("../../templates/application.yml", __FILE__)
    template = File.read(application_yml)
    file = location
    File.open(file, 'w+') do |f|
      f.write(ERB.new(template).result(binding))
    end
  end
end