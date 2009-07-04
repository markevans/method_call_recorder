class MethodCallRecorder

  def _play(object, &blk)
    i = 0
    _method_chain.inject(object) do |obj, method_call|
      i += 1
      yield(obj, method_call, _method_chain[i]) if block_given?
      method_call.call_on(obj)
    end
  end

  def _first_method
    _method_chain.first
  end
  
  def _empty?
    _method_chain.empty?
  end

  def to_s
    _method_chain.inspect
  end

  def _method_chain
    @_method_chain ||= []
  end
  
  def _to_setter(value)
    new_rec = self.dup
    new_rec._method_chain = self._method_chain.dup
    new_rec._method_chain[-1] = self._method_chain[-1].to_setter(value)
    new_rec
  end
  
  def _reset!
    self._method_chain = []
  end
  
  def _select(meth, args=nil)
    _method_chain.select do |method_call|
      selected = (method_call.method == meth)
      selected &&= (method_call.args == args) if args
      selected
    end
  end

  protected
  
  attr_writer :_method_chain

  private

  def method_missing(meth, *args)
    _method_chain << MethodCall.new(meth, *args)
    self
  end

end