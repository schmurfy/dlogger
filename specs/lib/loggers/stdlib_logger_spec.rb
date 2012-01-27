require_relative "../../common"

describe "Stdlib Logger" do
  before do
    @logger = DLogger::StdlibLogger.new('_default', $stdout)
  end
  
  should 'honor severity level' do
    Logger.any_instance.expects(:info).with('message : {}')
    @logger.log("message", :severity => :info)
    
    # default = debug
    Logger.any_instance.expects(:debug).with('message : {}')
    @logger.log("message")
  end  
  
end
