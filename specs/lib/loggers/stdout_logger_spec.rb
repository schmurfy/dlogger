require_relative "../../common"

describe "Logger" do
  before do
    @logger = DLogger::StdoutLogger.new
  end
  
  should 'write messages to stdout' do
    Kernel.expects(:puts).with('message : {}')
    @logger.log("message")
  end
  
end
