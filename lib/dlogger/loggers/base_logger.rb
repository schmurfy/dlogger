require 'thread'

module DLogger
  class BaseLogger
    def initialize(name = "_default")
      @name = name
      @mutex = Mutex.new
      context
    end
    
    def log(msg, data = {})
      @mutex.synchronize do
        result_data = {}
      
        # first load context data
        context.each do |ctx_data|
          case ctx_data
          when Hash
            result_data.merge!(ctx_data)
          
          when Extension
            ctx_data.class.properties.each do |attr_name|
              result_data[attr_name] = ctx_data.send(attr_name)
            end
            
          else
            raise "unsupported: #{ctx_data.inspect}"
          end
        end
      
        # then add our data
        result_data.merge!(data)
        
        # and dispatch the result
        dispatch(msg, result_data)
      end
    end
    
    def context
      Thread.current["#{@name}_dlogger_contexts"] ||= []
    end
    
    def with_context(context_data)
      if context_data.is_a?(Class)
        context << context_data.new
      else
        context << context_data
      end
      yield
    ensure
      # remove context
      context.pop
    end
    
  end
end

# 
# $logger = DLogger::Logger.new
# 
# 
# def do_something
#   $logger.log("I did it !", :return => "banana")
# end
# 
# th1 = Thread.new do
#   $logger.with_context(:request => "req1") do
#     do_something()
#   end
# end
# 
# 
# 
# th2 = Thread.new do
#   $logger.with_context(:request => "re2") do
#     do_something()
#   end
# end
# 
# 
# 
# [th1, th2].each(&:join)
# 
