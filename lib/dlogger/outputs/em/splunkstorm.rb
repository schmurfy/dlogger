gem 'eventmachine';     require 'eventmachine'
gem 'em-http-request';  require 'em-http-request'
gem 'yajl-ruby';        require 'yajl'

# 
module DLogger
  module Output
    
    class SplunkStorm < Base
      API_VERSION = 1
      ENDPOINT = 'inputs/http'
      
      def initialize(url, opts = {})
        @url = "#{url}/#{API_VERSION}/#{ENDPOINT}"
        
        @access_token = opts.delete(:access_token)
        
        @event_params = {
            :sourcetype => 'json_auto_timestamp',
            :host       => opts.delete(:host),
            :project    => opts.delete(:project)
          }
        
        raise ":access_token required" unless @access_token
        raise ":host required" unless @event_params[:host]
        raise ":project required" unless @event_params[:project]
        
        raise "unknown options: #{opts.inspect}" unless opts.empty?
      end
      
      def dispatch(msg, metadata)
        metadata = metadata.merge(:message => msg)
        http = EM::HttpRequest.new(@url).post(
            :query  => @event_params,
            :head   => {'authorization' => [@access_token, 'x']},
            :body   => Yajl::Encoder.encode(metadata)
          )

        # http.errback do
        #   p "ERR: #{http.response_header}"
        # end
        
      end
      
    end
    
  end
end
