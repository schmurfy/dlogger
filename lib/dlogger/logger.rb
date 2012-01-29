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
    
    ##
    # Main entry point, log a message with
    # its metadata.
    # 
    # @param [String] msg the message
    # @param [Hash] metadata Additional data
    # 
    def log(msg, metadata = {})
      @mutex.synchronize do
        # clearing a small hash is slightly faster than creating a new
        # one each time.
        merged_metadata.clear
      
        # first load context data
        context.each do |ctx_data|
          case ctx_data
          when Hash
            merged_metadata.merge!(ctx_data)
          
          when Extension
            ctx_data.class.properties.each do |attr_name|
              merged_metadata[attr_name] = ctx_data.send(attr_name)
            end
            
          else
            raise "unsupported: #{ctx_data.inspect}"
          end
        end
      
        # then add our data
        merged_metadata.merge!(metadata)
        
        # and dispatch the result
        dispatch(msg, merged_metadata)
      end
    end
    
    # Helper methods to mimic the standard ruby logger interface.
    %w(debug info error warn).each do |level|
      define_method(level) do |msg, metadata = {}|
        log(msg, metadata.merge(:severity => level.to_sym))
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
    
    ##
    # add context data for any log sent within the given block.
    # 
    # @param [Hash, Dlogger::Extension] context_data additional informations
    #   to include in logs
    # 
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
    
  
  private
    
    ##
    # Store the context in fiber local variables, each
    # Thread/Fiber gets its own.
    def context
      Thread.current["#{@name}_dlogger_contexts"] ||= []
    end
    
    ##
    # Store the temporary hash used to merge contexts.
    # 
    def merged_metadata
      Thread.current["#{@name}_dlogger_merged_metadata"] ||= {}
    end
    
    ##
    # Dispatch messages to all registered outputs.
    # 
    # @param [String] msg the log message
    # @param [Hash] metadata a hash including all the
    #   additional informations you want to make available
    # 
    def dispatch(msg, metadata)
      @outputs.each do |out|
        out.dispatch(msg, metadata)
      end
    end
    
  end
end
