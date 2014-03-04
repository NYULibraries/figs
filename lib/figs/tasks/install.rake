require 'erb'
require 'pathname'
require 'figs/figfile'
desc 'Install Fig'
task :install do |task, args|
  base_dir = Pathname.new('.')
  locations = args.extras.empty? ? "application.yml" :  args.extras
  figfile = Figs::Figfile.new(*locations)
  
  create_figfile base_dir, figfile
  create_non_existent_yaml(figfile.locations) if figfile.method.eql?("path")
  
  puts "[Done] Enjoy your figs sir!"
end

def create_figfile(base_dir, figfile)
  puts "Figsifying #{base_dir}/ ..."
  file = base_dir.join('Figfile')
  File.open(file, 'w+') do |f|
    f.write(figfile.to_yaml)
  end
end

def create_non_existent_yaml(locations)
  locations.each do |file|
    if !File.exists?(file)
      puts "[Add] #{file} does not exist, creating."
      application_yml = File.expand_path("../../templates/application.yml", __FILE__)
      File.open(file, 'w+') do |f|
        f.write(ERB.new(File.read(application_yml)).result(binding))
      end
    end
  end
end