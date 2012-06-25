require_relative "../../../common"

require 'dlogger/outputs/em/logstash'

$n = 0

describe "LogStash Output" do
  before do
    @port = 4000 + ($n += 1)
    @received_data = ""
    
    tmp = @received_data
    
    @handler_class = Class.new(EM::Connection) do
      define_method(:receive_data) do |data|
        tmp << data
      end
    end
    
    
    @server = EM::start_server('127.0.0.1', @port, @handler_class)
    
    @logger = DLogger::Output::LogStash.new('127.0.0.1', @port)
  end
  
  should 'send message to logstash' do
    @logger.dispatch('a log message', {:data => "something", :n => 21})
    
    wait(0.1) do
      @received_data.should == "{\"data\":\"something\",\"n\":21,\"message\":\"a log message\"}\n"
    end
  end
  
end
