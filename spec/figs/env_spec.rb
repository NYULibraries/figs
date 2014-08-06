require "spec_helper"



describe Figs::ENV do
  subject(:env) { Figs::ENV }
  
  before do
    env.delete("HELLO")
    env.delete("foo")
    env["arr"] = ["array"]
    ENV["HELLO"] = "world"
    ENV["foo"] = "bar"
  end

  after do
    ENV.delete("HELLO")
    ENV.delete("foo")
    env.delete("arr")
  end

  describe '#set' do
    after { ENV.delete(key) }
    let(:key) { 'VAR_NAME' }
    before { env.set(key, value) }
    context 'when the value is a String' do
      let(:value) { 'value' }
      it 'should set the String in the environment' do
        expect(ENV[key]).to eq 'value'
      end
      it 'should equal the value in the Figs::ENV' do
        expect(env[key]).to eq value
      end
    end
    context 'when the value is an Integer' do
      let(:value) { 1 }
      it 'should set the Integer as a String in the environment' do
        expect(ENV[key]).to eq '1'
      end
      it 'should equal the value in the Figs::ENV' do
        expect(env[key]).to eq value
      end
    end
    context 'when the value is a Float' do
      let(:value) { 2.0 }
      it 'should set the Float as a String in the environment' do
        expect(ENV[key]).to eq '2.0'
      end
      it 'should equal the value in the Figs::ENV' do
        expect(env[key]).to eq value
      end
    end
    context 'when the value is true' do
      let(:value) { true }
      it 'should set true as a String in the environment' do
        expect(ENV[key]).to eq 'true'
      end
      it 'should be true in the Figs::ENV' do
        expect(env[key]).to be true
      end
    end
    context 'when the value is false' do
      let(:value) { false }
      it 'should set false as a String in the environment' do
        expect(ENV[key]).to eq 'false'
      end
      it 'should be false in the Figs::ENV' do
        expect(env[key]).to be false
      end
    end
    context 'when the value is a Time' do
      let(:value) { Time.now }
      it 'should set the Time as a String in ISO8601 format in the environment' do
        expect(ENV[key]).to eq value.iso8601
      end
      it 'should be within a second of the value in the Figs::ENV' do
        expect(env[key]).to be_within(1).of value
      end
    end
    context 'when the value is a Date' do
      let(:value) { Time.now.to_date }
      it 'should set the Date in ISO8601 format in the environment' do
        expect(ENV[key]).to eq value.iso8601
      end
      it 'should equal the value in the Figs::ENV' do
        expect(env[key]).to eq value
      end
    end
    context 'when the value is nil' do
      let(:value) { nil }
      it 'should set the value "~" in the environment' do
        expect(ENV[key]).to eq '~'
      end
      it 'should be nil in the Figs::ENV' do
        expect(env[key]).to be_nil
      end
    end
    context 'when the value is not a YAML for Ruby "basic type"' do
      let(:value) { {key: 1} }
      it 'should set a YAML string representation of the value in the environment' do
        expect(ENV[key]).to eq "---\n:key: 1\n"
      end
      it 'should equal the value in the Figs::ENV' do
        expect(env[key]).to eq value
      end
    end
  end
  
  describe "#[]=" do
    context "objects" do
      it "should" do
        expect(env["arr"] ).to eql(["array"])
        expect(env.arr).to eql(["array"])
      end
    end
  end

  describe "#method_missing" do
    context "plain methods" do
      it "makes ENV values accessible as lowercase methods" do
        expect(env.hello).to eq("world")
        expect(env.foo).to eq("bar")
      end
  
      it "makes ENV values accessible as uppercase methods" do
        expect(env.HELLO).to eq("world")
        expect(env.FOO).to eq("bar")
      end
      
      it "makes ENV values accessible as mixed-case methods" do
        expect(env.Hello).to eq("world")
        expect(env.fOO).to eq("bar")
      end
      
      it "returns nil if no ENV key matches" do
        expect(env.goodbye).to eq(nil)
      end
    end
  
    context "bang methods" do
      it "makes ENV values accessible as lowercase methods" do
        expect(env.hello!).to eq("world")
        expect(env.foo!).to eq("bar")
      end
  
      it "makes ENV values accessible as uppercase methods" do
        expect(env.HELLO!).to eq("world")
        expect(env.FOO!).to eq("bar")
      end
  
      it "makes ENV values accessible as mixed-case methods" do
        expect(env.Hello!).to eq("world")
        expect(env.fOO!).to eq("bar")
      end
  
      it "raises an error if no ENV key matches" do
        expect { env.goodbye! }.to raise_error(Figs::MissingKey)
      end
    end
  
    context "boolean methods" do
      it "returns true for accessible, lowercase methods" do
        expect(env.hello?).to eq(true)
        expect(env.foo?).to eq(true)
      end
  
      it "returns true for accessible, uppercase methods" do
        expect(env.HELLO?).to eq(true)
        expect(env.FOO?).to eq(true)
      end
  
      it "returns true for accessible, mixed-case methods" do
        expect(env.Hello?).to eq(true)
        expect(env.fOO?).to eq(true)
      end
  
      it "returns false if no ENV key matches" do
        expect(env.goodbye?).to eq(false)
      end
    end
  
    context "setter methods" do
      it "raises an error" do
        expect { env.foo = "bar" }.to raise_error(NoMethodError)
      end
    end
  end
  
  describe "#respond_to?" do
    context "plain methods" do
      context "when ENV has the key" do
        it "is true for a lowercase method" do
          expect(env.respond_to?(:hello)).to eq(true)
          expect(env.respond_to?(:foo)).to eq(true)
        end
  
        it "is true for a uppercase method" do
          expect(env.respond_to?(:HELLO)).to eq(true)
          expect(env.respond_to?(:FOO)).to eq(true)
        end
  
        it "is true for a mixed-case key" do
          expect(env.respond_to?(:Hello)).to eq(true)
          expect(env.respond_to?(:fOO)).to eq(true)
        end
      end
  
      context "when ENV doesn't have the key" do
        it "is true" do
          expect(env.respond_to?(:baz)).to eq(true)
        end
      end
    end
  
    context "bang methods" do
      context "when ENV has the key" do
        it "is true for a lowercase method" do
          expect(env.respond_to?(:hello!)).to eq(true)
          expect(env.respond_to?(:foo!)).to eq(true)
        end
  
        it "is true for a uppercase method" do
          expect(env.respond_to?(:HELLO!)).to eq(true)
          expect(env.respond_to?(:FOO!)).to eq(true)
        end
  
        it "is true for a mixed-case key" do
          expect(env.respond_to?(:Hello!)).to eq(true)
          expect(env.respond_to?(:fOO!)).to eq(true)
        end
      end
  
      context "when ENV doesn't have the key" do
        it "is false" do
          expect(env.respond_to?(:baz!)).to eq(false)
        end
      end
    end
  
    context "boolean methods" do
      context "when ENV has the key" do
        it "is true for a lowercase method" do
          expect(env.respond_to?(:hello?)).to eq(true)
          expect(env.respond_to?(:foo?)).to eq(true)
        end
  
        it "is true for a uppercase method" do
          expect(env.respond_to?(:HELLO?)).to eq(true)
          expect(env.respond_to?(:FOO?)).to eq(true)
        end
  
        it "is true for a mixed-case key" do
          expect(env.respond_to?(:Hello?)).to eq(true)
          expect(env.respond_to?(:fOO?)).to eq(true)
        end
      end
  
      context "when ENV doesn't have the key" do
        it "is true" do
          expect(env.respond_to?(:baz?)).to eq(true)
        end
      end
    end
  
    context "setter methods" do
      context "when ENV has the key" do
        it "is true" do
          expect(env.respond_to?(:foo=)).to eq(false)
        end
      end
  
      context "when ENV doesn't have the key" do
        it "is true" do
          expect(env.respond_to?(:baz=)).to eq(false)
        end
      end
    end
  end
end
