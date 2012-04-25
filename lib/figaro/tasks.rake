require "json"
require "openssl"
require "base64"

namespace :figaro do
  desc "Configure Heroku according to application.yml"
  task :heroku, [:app] => :environment do |_, args|
    Figaro::Tasks.heroku(args[:app])
  end

  desc "Configure Travis according to application.yml"
  task :travis, [:vars] => :environment do |_, args|
    remotes = Kernel.system("git remote --verbose")
    match = remotes.match(/git@github\.com:([^\s]+)/)
    slug = match && match[1].sub(/\.git$/, "")
    json = Net::HTTP.get("travis-ci.org", "/#{slug}.json")
    public_key = JSON.parse(json)["public_key"]
    rsa = OpenSSL::PKey::RSA.new(public_key)
    env = Figaro.env
    env.merge!(Hash[*args[:vars].split(/[\s=]/)]) if args[:vars]
    vars = env.map{|k,v| "#{k}=#{v}" }.sort.join(" ")
    secure = Base64.encode64(rsa.public_encrypt(vars)).rstrip
    path = Rails.root.join(".travis.yml")
    if path.exist?
      travis = YAML.load_file(path)
      travis["env"] = {"secure" => secure}
      yaml = YAML.dump(travis)
    else
      yaml = YAML.dump("env" => {"secure" => secure})
    end
    path.open("w"){|f| f.write(yaml) }
  end
end
