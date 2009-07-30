class MethodCallLogger
  
  def initialize
    @recorders = []
    @method_log = []
  end
  
  def register(*rec_objects)
    rec_objects.each do |rec|
      rec._on_method_call{|r| method_log << [r, r._last_method] }
      recorders << rec
    end
  end
  
  attr_reader :recorders, :method_log
  
end