%w{method_call method_call_recorder}.each do |file|
  require File.dirname(__FILE__)+'/method_call_recorder/'+file
end