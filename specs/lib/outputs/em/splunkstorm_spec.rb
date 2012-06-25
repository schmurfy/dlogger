require_relative "../../../common"

require 'dlogger/outputs/em/splunkstorm'

$n = 0

describe "SplunkStorm Output" do
  before do
    @http_port = 4000 + ($n += 1)
    
    @request_uri = ""
    @received_data = ""
    
    received_data = @received_data
    request_uri = @request_uri
    
    start_server do |rack|
      run ->(env){
        request_uri << env['REQUEST_URI']
        received_data << env['rack.input'].read()
        [200, {}, []]
      }
    end
    
    
    # 1/inputs/http
    @logger = DLogger::Output::SplunkStorm.new("http://127.0.0.1:#{@http_port}",
        :host         => 'test.com',
        :access_token => "TOKEN",
        :project      => "PR"
      )
  end
  
  should 'send message to logstash' do
    @logger.dispatch('a log message', {:data => "something", :n => 21})
    
    wait(0.1) do
      @request_uri.should == "/1/inputs/http?sourcetype=json_auto_timestamp&host=test.com&project=PR"
      @received_data.should == "{\"data\":\"something\",\"n\":21,\"message\":\"a log message\"}"
    end
  end
  
end
