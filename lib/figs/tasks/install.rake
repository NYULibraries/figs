require 'erb'
require 'pathname'
desc 'Install Fig'
task :install do |task, args|
  base_dir = Pathname.new('.')
  puts "Figsifying #{base_dir}/ ..."
  locations = args.extras || "application.yml"
  method = locations.first.downcase.end_with?(".git") ? "git" : "path"
  
  puts "Figs yaml located at #{locations.join(", ")} using #{method} method."
  
  file = base_dir.join('Figfile')
  File.open(file, 'w+') do |f|
    f.write("location: ")
    locations.each { |location| f.write("\n - #{location}")}
    f.write("\nmethod: #{method}")
  end
  
  if method.eql?("path")
    locations.each do |location|
      if !File.exists?(location)
        puts "[Add] #{location} does not exist, creating."
        application_yml = File.expand_path("../../templates/application.yml", __FILE__)
        template = File.read(application_yml)
        file = location
        File.open(file, 'w+') do |f|
          f.write(ERB.new(template).result(binding))
        end
      end
    end
  end
  
  puts "[Done] Enjoy your figs sir!"
end