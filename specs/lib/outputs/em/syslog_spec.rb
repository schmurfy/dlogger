require_relative "../../../common"

require 'dlogger/outputs/em/syslog'

$n = 0

describe "Syslog Output" do
  before do
    @port = 4000 + ($n += 1)
    @received_data = ""
    
    tmp = @received_data
    
    @handler_class = Class.new(EM::Connection) do
      define_method(:receive_data) do |data|
        tmp << data
      end
    end
    
    
    # @server = EM::start_server('127.0.0.1', @port, @handler_class)
    @server = EM::open_datagram_socket('127.0.0.1', @port, @handler_class)
    
    @logger = DLogger::Output::Syslog.new('127.0.0.1', @port)
  end
  
  should 'send message to syslog via UDP' do
    t = "Apr 15 16:46:32"
    
    freeze_time(Time.parse(t)) do
      @logger.dispatch('a log message', {:data => "something", :n => 21})
      
      wait(0.1) do
        @received_data.should == %{<6>#{t} unused app: {"data":"something","n":21,"message":"a log message"}}
      end
    end
  end
  
end
