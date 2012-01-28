require 'logger'

module DLogger
  module Output
    
    ##
    # Outputs data to stdout.
    # 
    class Stdout < Base
      
      ##
      # @param [Boolean] dump_metadata if true the output will
      #   include the metadata dumped with inspect
      # 
      def initialize(dump_metadata = true)
        @dump_metadata = dump_metadata
      end
      
      ##
      # @see Logger::dispatch
      #
      def dispatch(msg, metadata)
        if @dump_metadata
          Kernel.puts("#{msg} : #{metadata.inspect}")
        else
          Kernel.puts(msg)
        end
      end
      
    end
  end
  
end
