require_relative "../../common"

describe "Stdlib Logger" do
  before do
    @out = DLogger::Output::StdlibLogger.new( Logger.new($stdout) )
  end
  
  should 'honor severity level' do
    Logger.any_instance.expects(:info).with('message : {}')
    @out.dispatch("message", :severity => :info)
  end
  
  should 'use debug as default for severity level' do
    # default = debug
    Logger.any_instance.expects(:debug).with('message : {}')
    @out.dispatch("message", {})
  end  
  
  should 'not log metadata when asked' do
    out = DLogger::Output::StdlibLogger.new( Logger.new($stdout), false )
    Logger.any_instance.expects(:debug).with('message')
    out.dispatch("message", {})
  end
  
end
