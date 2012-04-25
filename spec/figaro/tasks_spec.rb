require "spec_helper"

describe Figaro::Tasks do
  describe ".heroku" do
    it "configures Heroku" do
      Figaro.stub(:vars => "FOO=bar")

      Figaro::Tasks.should_receive(:`).once.with("heroku config:get RAILS_ENV").
        and_return("development\n")
      Figaro::Tasks.should_receive(:`).once.with("heroku config:add FOO=bar")

      Figaro::Tasks.heroku
    end

    it "configures a specific Heroku app" do
      Figaro.stub(:vars => "FOO=bar")

      Figaro::Tasks.should_receive(:`).once.
        with("heroku config:get RAILS_ENV --app my-app").
        and_return("development\n")
      Figaro::Tasks.should_receive(:`).once.
        with("heroku config:add FOO=bar --app my-app")

      Figaro::Tasks.heroku("my-app")
    end

    it "respects the Heroku's remote Rails environment" do
      Figaro::Tasks.stub(:`).with("heroku config:get RAILS_ENV").
        and_return("production\n")

      Figaro.should_receive(:vars).once.with("production").and_return("FOO=bar")
      Figaro::Tasks.should_receive(:`).once.with("heroku config:add FOO=bar")

      Figaro::Tasks.heroku
    end

    it "defaults to the local Rails environment if not set remotely" do
      Figaro::Tasks.stub(:`).with("heroku config:get RAILS_ENV").
        and_return("\n")

      Figaro.should_receive(:vars).once.with(nil).and_return("FOO=bar")
      Figaro::Tasks.should_receive(:`).once.with("heroku config:add FOO=bar")

      Figaro::Tasks.heroku
    end

    describe "figaro:heroku", :rake => true do
      it "configures Heroku" do
        Figaro::Tasks.should_receive(:heroku).once.with(nil)

        task.invoke
      end

      it "configures a specific Heroku app" do
        Figaro::Tasks.should_receive(:heroku).once.with("my-app")

        task.invoke("my-app")
      end
    end
  end

  describe "figaro:travis" do
    let(:travis_path){ ROOT.join("tmp/.travis.yml") }
    let(:rsa){ OpenSSL::PKey::RSA.generate(1024) }
    let(:public_key){ rsa.public_key.to_s }
    let(:private_key){ rsa.to_pem }
    let(:travis_yml){ YAML.load_file(travis_path) }
    let(:decrypted){ decrypt(travis_yml["env"]) }

    def decrypt(value)
      case value
      when Hash then rsa.private_decrypt(Base64.decode64(value["secure"]))
      when Array then value.map{|v| decrypt(v) }
      end
    end

    before do
      Figaro.stub(:env => {"HELLO" => "world", "FOO" => "bar"})
      Rails.stub(:root => ROOT.join("tmp"))
      Kernel.should_receive(:system).with("git remote --verbose").and_return("origin\tgit@github.com:bogus/repo.git (fetch)\norigin\tgit@github.com:bogus/repo.git (push)")
      stub_request(:get, "http://travis-ci.org/bogus/repo.json").to_return(:body => JSON.generate({"public_key" => public_key}))
    end

    after do
      travis_path.delete if travis_path.exist?
    end

    context "with no .travis.yml" do
      it "creates .travis.yml" do
        task.invoke
        travis_path.should exist
      end

      it "adds encrypted vars to .travis.yml env" do
        task.invoke
        decrypted.should == "FOO=bar HELLO=world"
      end

      it "merges additional vars" do
        task.invoke("LASER=lemon FOO=baz")
        decrypted.should == "FOO=baz HELLO=world LASER=lemon"
      end
    end

    def write_travis_yml(content)
      travis_path.open("w"){|f| f.write(content) }
    end

    context "with no env in .travis.yml" do
      before do
        write_travis_yml("language: ruby")
      end

      it "appends env to .travis.yml" do
        task.invoke
        decrypted.should == "FOO=bar HELLO=world"
        travis_yml["language"].should == "ruby"
      end

      it "merges additional vars" do
        task.invoke("LASER=lemon FOO=baz")
        decrypted.should == "FOO=baz HELLO=world LASER=lemon"
        travis_yml["language"].should == "ruby"
      end
    end
  end
end
