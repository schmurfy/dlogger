require_relative "../../common"

describe "Logger" do
  
  should 'write messages to stdout' do
    out = DLogger::Output::Stdout.new
    Kernel.expects(:puts).with('message : {}')
    out.dispatch("message", {})
  end
  
  should 'write messages to stdout without metadata' do
    out = DLogger::Output::Stdout.new(false)
    Kernel.expects(:puts).with('message')
    out.dispatch("message", {})
  end
  
end
