require File.dirname(__FILE__) + '/spec_helper'

describe MethodCallLogger do
  
  describe "registering" do
    before(:each) do
      @logger = MethodCallLogger.new
      @rec1, @rec2, @rec3 = MethodCallRecorder.new, MethodCallRecorder.new, MethodCallRecorder.new
    end
    it "should return the registered method call recorders" do
      @logger.register @rec1
      @logger.register @rec2, @rec3
      @logger.recorders.should == [@rec1,@rec2,@rec3]
    end
    it "should log each time a method is called" do
      @logger.register @rec1, @rec2
      @rec2.eat[2]
      @rec1.as_well
      @logger.method_log.should == [
        [@rec2, MethodCall.new(:eat)],
        [@rec2, MethodCall.new(:[],2)],
        [@rec1, MethodCall.new(:as_well)]
      ]
    end
  end
  
end