require "spec_helper"

require "tempfile"

module Figs
  describe Application do
    before do
      Application.any_instance.stub(
        default_figsfile: "",
        default_path: "/path/to/app/config/application.yml",
        default_stage: "development"
      )
    end

    describe "#path" do
      it "uses the default" do
        application = Application.new
        expect(application.path).to eq("/path/to/app/config/application.yml")
      end
    
      it "is configurable via initialization" do
        application = Application.new(file: YAML.load("locations: /app/env.yml\nmethod: path"))
      
        expect(application.path).to eq("/app/env.yml")
      end
    
      it "is configurable via setter" do
        application = Application.new
        application.path = "/app/env.yml"
      
        expect(application.path).to eq("/app/env.yml")
      end
    
      it "casts to string" do
        application = Application.new(file: YAML.load("locations: /app/env.yml\nmethod: path"))
      
        expect(application.path).to eq("/app/env.yml")
        expect(application.stage).not_to be_a(Pathname)
      end
    
      it "follows a changing default" do
        application = Application.new
    
        expect {
          application.stub(default_path: "/app/env.yml")
        }.to change {
          application.path
        }.from("/path/to/app/config/application.yml").to("/app/env.yml")
      end
      
      it "allows multiple files" do
        application = Application.new(file: YAML.load("locations:\n- /app/env1.yml\n- /app/env2.yml\nmethod: path"))
        
        expect(application.path).to eq(["/app/env1.yml","/app/env2.yml"])
      end
      
      describe "git" do
        it "allows for a git repo" do
          application = Application.new(file: YAML.load("repo: https://github.com/hab278/test-figs.git\nlocations:\n- testing.yml\n- test.yml\nmethod: git"))

          expect(application.path).to_not eq(:default_path)
        end
      end
    end

    describe "#stage" do
      it "uses the default" do
        application = Application.new
      
        expect(application.stage).to eq("development")
      end
    
      it "is configurable via initialization" do
        application = Application.new(stage: "test")
    
        expect(application.stage).to eq("test")
      end
    
      it "is configurable via setter" do
        application = Application.new
        application.stage = "test"
    
        expect(application.stage).to eq("test")
      end
    
      it "casts to string" do
        application = Application.new(stage: :test)
    
        expect(application.stage).to eq("test")
        expect(application.stage).not_to be_a(Symbol)
      end
    
      it "follows a changing default" do
        application = Application.new
    
        expect {
          application.stub(default_stage: "test")
        }.to change {
          application.stage
        }.from("development").to("test")
      end
    end

    describe "#configuration" do
      def yaml_to_tmp_file(yaml)
        @tmpfile = Tempfile.new("fig")
        @tmpfile.open
        @tmpfile.write(yaml)
        @tmpfile.flush
        @tmpfile
      end
      
      def from_figsfile(path)
        YAML.load("locations: #{path}\nmethod: path")
      end

      it "loads values from YAML" do
        application = Application.new(file: from_figsfile(yaml_to_tmp_file(<<-YAML).path))
foo: bar
YAML

        expect(application.configuration).to eq("foo" => "bar")
      end

      it "merges environment-specific values" do
        application = Application.new(file: from_figsfile(yaml_to_tmp_file(<<-YAML).path), stage: "test")
foo: bar
test:
  foo: baz
YAML

        expect(application.configuration).to eq("foo" => "baz")
      end

#       it "drops unused environment-specific values" do
#         application = Application.new(file: from_figsfile(yaml_to_tmp_file(<<-YAML).path), stage: "test")
# foo: bar
# test:
#   foo: baz
# production:
#   foo: bad
# YAML
# 
#         expect(application.configuration).to eq("foo" => "baz")
#       end

      it "is empty when no YAML file is present" do
        application = Application.new(path: "/path/to/nowhere")

        expect(application.configuration).to eq({})
      end

      it "is empty when the YAML file is blank" do
        application = Application.new(path: yaml_to_tmp_file(""))

        expect(application.configuration).to eq({})
      end

      it "is empty when the YAML file contains only comments" do
        application = Application.new(path: yaml_to_tmp_file(<<-YAML).path)
# Comment
YAML

        expect(application.configuration).to eq({})
      end

      it "processes ERB" do
        application = Application.new(file: from_figsfile(yaml_to_tmp_file(<<-YAML).path))
foo: <%= "bar".upcase %>
YAML

        expect(application.configuration).to eq("foo" => "BAR")
      end

      it "follows a changing default path" do
        @temp_file_1 = yaml_to_tmp_file("foo: bar")
        @temp_file_2 = yaml_to_tmp_file("foo: baz")
      
        application = Application.new
        application.stub(default_path: @temp_file_1.path)
      
        expect {
          application.stub(default_path: @temp_file_2.path)
        }.to change {
          application.configuration
        }.from("foo" => "bar").to("foo" => "baz")
        
        @temp_file_1.close
        @temp_file_1.unlink
        @temp_file_2.close
        @temp_file_2.unlink
      end

#       it "follows a changing default environment" do
#         application = Application.new(file: from_figsfile(yaml_to_tmp_file(<<-YAML).path))
# foo: bar
# test:
#   foo: baz
# YAML
#         application.stub(default_stage: "development")
# 
#         expect {
#           application.stub(default_stage: "test")
#         }.to change {
#           application.configuration
#         }.from("foo" => "bar").to("foo" => "baz")
#       end
      
      it "picks up yaml from multiple files" do
        @temp_file1 = yaml_to_tmp_file("fooz: barz")
        @temp_file2 = yaml_to_tmp_file("foos: bars")
        application = Application.new(file: from_figsfile("\n- #{@temp_file1.path}\n- #{@temp_file2.path}"))
        
        expect(application.configuration).to eq("fooz" => "barz", "foos" => "bars") 
        @temp_file1.close
        @temp_file1.unlink
        @temp_file2.close
        @temp_file2.unlink
      end
      
      describe "git" do
        it "picks up yaml from git repo" do
          application = Application.new(file: YAML.load("repo: https://github.com/hab278/test-figs.git\nlocations:\n- testing.yml\n- test.yml\nmethod: git"))

          expect(application.configuration).to eq("fooz" => "barz", "foo" => "bar")
        end
      end
    end

    describe "#load" do
      let!(:application) { Application.new }
    
      before do
        ::ENV.delete("foo")
        ::ENV.delete("_FIGS_foo")
    
        application.stub(configuration: { "foo" => "bar" })
      end
    
      it "merges values into ENV" do
        expect {
          application.load
        }.to change {
          ::ENV["foo"]
        }.from(nil).to("bar")
      end
    
      it "skips keys that have already been set externally" do
        ::ENV["foo"] = "baz"
      
        expect {
          application.load
        }.not_to change {
          ::ENV["foo"]
        }
      end
    
      it "sets keys that have already been set internally" do
        application.load
    
        application2 = Application.new
        application2.stub(configuration: { "foo" => "baz" })
    
        expect {
          application2.load
        }.to change {
          ::ENV["foo"]
        }.from("bar").to("baz")
      end
    
      it "DOES NOT warn when a key isn't a string" do
        application.stub(configuration: { foo: "bar" })
    
        expect(application).to_not receive(:warn)
    
        application.load
      end
    
      it "DOES NOT warn when a value isn't a string" do
        application.stub(configuration: { "foo" => ["bar"] })
    
        expect(application).to_not receive(:warn)
    
        application.load
      end
    end
  end
end
