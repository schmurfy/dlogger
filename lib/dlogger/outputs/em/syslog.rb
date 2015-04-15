gem 'eventmachine'; require 'eventmachine'
gem 'multi_json'; require 'multi_json'
gem 'syslog_protocol'; require 'syslog_protocol'

module DLogger
  module Output
    
    ##
    # This is not strictly a standard syslog output but it is designed
    # to be used with rsyslog as a pass trhough to send data to elasticsearch
    #
    class Syslog < Base
      def initialize(host, port, bind_address: '0.0.0.0')
        @host         = host
        @port         = port
        
        @socket = EM::open_datagram_socket(bind_address, 0)
      end
            
      def dispatch(msg, metadata)
        metadata = metadata.merge(message: msg)
        
        p = SyslogProtocol::Packet.new
        p.hostname  = "unused"
        p.facility  = "kern"
        p.severity  = "info"
        p.tag       = "app"
        p.content   = MultiJson.encode(metadata)
        
        @socket.send_datagram(p.to_s, @host, @port)
      end
      
    end
    
  end
end
  
