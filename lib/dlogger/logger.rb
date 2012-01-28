require 'thread'

module DLogger
  class Logger
    def initialize(name = "_default")
      @name = name
      @mutex = Mutex.new
      @outputs = []
      
      # initialize context
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
    
    def dispatch(msg, metadata)
      @outputs.each do |out|
        out.dispatch(msg, metadata)
      end
    end
    
    ##
    # Register a new output, the only requirement is that
    # the object passed reponds to the "dispatch" method.
    # 
    # @param [Object] handler the handler
    # 
    def add_output(handler)
      @outputs << handler
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
