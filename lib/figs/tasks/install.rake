require 'erb'
require 'pathname'
require 'figs/figsfile'
desc 'Install Fig'
task :install do |task, args|
  base_dir = Pathname.new('.')
  locations = args.extras.empty? ? "application.yml" :  args.extras
  figsfile = Figs::Figsfile.new(*locations)
  
  create_figsfile base_dir, figsfile
  create_non_existent_yaml(figsfile.locations) if figsfile.method.eql?("path")
  
  puts "[Done] Enjoy your figs sir!"
end

def create_figsfile(base_dir, figsfile)
  puts "Figsifying #{base_dir}/ ..."
  file = base_dir.join('Figsfile')
  File.open(file, 'w+') do |f|
    f.write(figsfile.to_yaml)
  end
end

def create_non_existent_yaml(locations)
  locations.each do |file|
    if !File.exists?(file) && !Dir.exists?(file)
      puts "[Add] #{file} does not exist, creating."
      application_yml = File.expand_path("../../templates/application.yml", __FILE__)
      File.open(file, 'w+') do |f|
        f.write(ERB.new(File.read(application_yml)).result(binding))
      end
    end
  end
end