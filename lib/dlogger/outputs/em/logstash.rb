gem 'eventmachine'; require 'eventmachine'
gem 'yajl-ruby';    require 'yajl'

module DLogger
  module Output
    
    module LogStashHandler
      def initialize(master)
        @master = master
      end
      
      def unbind
        if @master
          tmp = @master
          EM::add_timer(0.2){ tmp.connect }
          @master = nil
        end
      end
    end
    
    class LogStash < Base
      def initialize(host, port)
        @host = host
        @port = port
        connect
      end
      
      def connect
        @socket = EM::connect(@host, @port, LogStashHandler, self)
      end
      
      def dispatch(msg, metadata)
        metadata = metadata.merge(:message => msg)
        @socket.send_data( Yajl::Encoder.encode(metadata) + "\n" )
      end
    end
    
  end
end