require "#{File.dirname(__FILE__)}/spec_helper"

def stub_method_call(*args)
  method_call = mock('method_call')
  MethodCall.stub!(:new).with(*args).and_return method_call
  method_call
end

describe MethodCallRecorder do

  before(:each) do
    @rec = MethodCallRecorder.new
  end

  it "should allow any combination of chained methods on it" do
    lambda do
      MethodCallRecorder.new.egg[23]['fish'].another = 5
      MethodCallRecorder.new[:twenty].what.the / 8 * 4 + 1
    end.should_not raise_error
  end

  it "should save methods called on it in it's 'method chain'" do
    mc1 = stub_method_call(:this, :should)
    mc2 = stub_method_call(:[], 'be')
    mc3 = stub_method_call(:saved)
    @rec.this(:should)['be'].saved
    @rec._method_chain.should == [mc1, mc2, mc3]
  end

  it "should be able to play back its method chain on another object" do
    inner = mock('inner', :duck => 'hello')
    struct = mock('struct', :fish => inner)
    obj = { :a => [struct, 2] }
    @rec[:a][0].fish.duck
    @rec._play(obj).should == 'hello'
  end

  it "should just return the object on play if its method chain is empty" do
    obj = Object.new
    @rec._play(obj).should == obj
  end

  it "should record append to the method chain if you record twice" do
    mc1 = stub_method_call(:once)
    mc2 = stub_method_call(:twice)
    @rec.once
    @rec._method_chain.should == [mc1]
    @rec.twice
    @rec._method_chain.should == [mc1, mc2]
  end

  it "should allow resetting the method chain" do
    mc = stub_method_call(:some_method)
    @rec.some_method
    @rec._method_chain.should == [mc]
    @rec._reset!
    @rec._method_chain.should == []
  end

  it "should yield the current sub object, and the next two methods to be called as it plays back" do
    mc1 = MethodCall.new(:[], :hello)
    mc2 = MethodCall.new(:[], 2)
    mc3 = MethodCall.new(:eggy_bread)
    str = 'yes'
    def str.eggy_bread; 'egg'; end
    @rec[:hello][2].eggy_bread
    yielded_values = []
    @rec._play({:hello => ['no','and',str]}) do |obj, method_call, next_method_call|
      yielded_values << [obj, method_call, next_method_call]
    end
    yielded_values.should == [
      [ {:hello => ['no','and',str]}, mc1, mc2 ],
      [ ['no','and',str],             mc2, mc3 ],
      [ str,                          mc3, nil ]
    ]
  end

  it "should return the first method called on it" do
    @rec.hello.how.are['you']
    @rec._first_method.should == MethodCall.new(:hello)
  end

  it "should return itself" do
    @rec.hello[4].this(:is).now('innit').should == @rec
  end
  
  it "should return a clone of itself with the last method as a setter" do
    mc1 = MethodCall.new(:[], :hello)
    mc2 = MethodCall.new(:there)
    mc3 = MethodCall.new(:there=, 4)
    @rec[:hello].there
    other_rec = @rec._to_setter(4)
    @rec._method_chain.should      == [mc1, mc2]
    other_rec._method_chain.should == [mc1, mc3]
  end

  it "should say if empty" do
    @rec._empty?.should be_true
  end
  
  it "should say if not empty" do
    @rec.hello._empty?.should be_false
  end
  
  describe "selecting methods" do
    before :each do
      @rec.this[:is, 2].a(3, 'go').metho[:call].a('yo')
      @m1, @m2, @m3, @m4, @m5, @m6 = @rec._method_chain
    end
    
    it "should select matching only on method" do
      @rec._select(:[]).should == [@m2, @m5]
      @rec._select(:a).should == [@m3, @m6]
    end
    
    it "should select matching on method and args" do
      @rec._select(:[], [:call]).should == [@m5]
      @rec._select(:a, ['yo']).should == [@m6]
    end

  end
  
  describe "blocks" do
    it "should save the block for a method call in the method call" do
      @rec.hello{|t| t + 4 }
      @rec._method_chain.first.block.should be_a(Proc)
    end
  end

  describe "callback on method call" do
    it "should do the callback on every method call" do
      methods = []
      @rec._on_method_call{|rec| methods << rec._last_method.method }
      @rec.hi[:there]
      methods.should == [:hi,:[]]
    end
  end
  
  describe "owner" do
    it "should have an owner" do
      obj = Object.new
      @rec._owner = obj
      @rec._owner.should == obj
    end
  end

  describe "string representation" do
    it "should use the args_string method of method call" do
      @rec.hello[:there]
      @rec._method_chain.first.should_receive(:args_string).and_return '.hello'
      @rec._method_chain.last.should_receive(:args_string).and_return '[:there]'
      @rec._to_s.should == 'obj.hello[:there]'
    end
  end
  
  describe "comparing with other method call recorders" do
    before(:each) do
      @rec2 = MethodCallRecorder.new
    end
    it "should return true when equal method calls" do
      @rec.hello[:there].how('are',:you?)[1..2]
      @rec2.hello[:there].how('are',:you?)[1..2]
      @rec._eql?(@rec2).should be_true
    end
    it "should return false when not equal calls" do
      @rec.hello[:there]
      @rec2.hello[:here]
      @rec._eql?(@rec2).should be_false
    end
  end

end