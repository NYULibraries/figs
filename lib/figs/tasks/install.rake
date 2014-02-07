require 'erb'
require 'pathname'
desc 'Install Fig'
task :install, :location, :remote do |task, args|
  base_dir = Pathname.new('.')
  puts "Figsifying #{base_dir}/ ..."
  location = args[:location] || "application.yml"
  method = location.end_with?(".git") ? "git" : "path"
  
  puts "Figs yaml located at #{location} using #{method} method."
  
  file = base_dir.join('Figfile')
  File.open(file, 'w+') do |f|
    f.write("location: #{location}\nmethod: #{method}")
  end
  
  if !File.exists?(location) && method.eql?("path")
    puts "[Add] #{location} does not exist, creating."
    application_yml = File.expand_path("../../templates/application.yml", __FILE__)
    template = File.read(application_yml)
    file = location
    File.open(file, 'w+') do |f|
      f.write(ERB.new(template).result(binding))
    end
  end
  
  puts "[Done] Enjoy your figs sir!"
end