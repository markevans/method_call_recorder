class MethodCall

  def initialize(meth, *args, &blk)
    @method, @args = meth, args
    @block = blk
  end

  attr_reader :method, :args, :block

  def call_on(obj)
    obj.send(method, *args)
  end

  def to_a
    [method, *args]
  end

  def setter?
    !!(method.to_s =~ /=$/)
  end

  def getter?
    !setter?
  end

  def to_setter(value)
    new_method_call = self.deep_dup
    if setter?
      new_method_call.args[-1] = value
    else
      new_method_call.args << value
      new_method_call.method = "#{new_method_call.method}=".to_sym
    end
    new_method_call
  end

  def type
    case method.to_s
    when '[]'  then (args.first.is_a?(Fixnum) ? :array_reader : :hash_reader)
    when '[]=' then (args.first.is_a?(Fixnum) ? :array_writer : :hash_writer)
    when /\=$/ then :attr_writer
    else :attr_reader
    end
  end

  def guess_receiver_type
    case type
    when :array_reader, :array_writer then Array
    when :hash_reader,  :hash_writer then Hash
    end
  end

  def ==(other)
    self.method == other.method && self.args == other.args
  end

  def deep_dup
    self.class.new(method, *args, &block)
  end

  def to_s
    "obj#{args_string}"
  end

  def args_string
    args_str = args.map(&:inspect)
    case type
    when :attr_reader
      args.any? ? ".#{method}(#{args_str.join(',')})" : ".#{method}"
    when :attr_writer
      ".#{method}#{args_str.join(',')}" # There should only be one arg but just in case
    when :array_reader, :hash_reader
      "[#{args_str.join(',')}]"
    when :array_writer, :hash_writer
      "[#{args_str[0...-1].join(',')}]=#{args_str.last}"
    end.gsub(' ','')
  end

  protected

  attr_writer :method

end
