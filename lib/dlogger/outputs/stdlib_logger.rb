module DLogger
  module Output
    
    ##
    # Output data to a standard ruby logger.
    class StdlibLogger < Base
      
      ##
      # @param [Logger] logger a ruby logger
      # 
      def initialize(logger, dump_metadata = true)
        @logger = logger
        @dump_metadata = dump_metadata
      end
      
      ##
      # @see Logger::dispatch
      # 
      def dispatch(msg, metadata)
        severity = metadata.delete(:severity) || :debug
        msg = @dump_metadata ? "#{msg} : #{metadata.inspect}" : msg
        @logger.send(severity, msg)
      end
      
    end
  end
end
