require_relative "../../common"

describe "Logger" do
  before do
    @logger = DLogger::BaseLogger.new
  end
  
  should "dispatch msg with its data" do
    @logger.expects(:dispatch).with("the message", :id => 43, :user => 'bob')
    @logger.log("the message", :id => 43, :user => "bob")
  end
  
  describe 'with hash context' do
    should 'dispatch msg and merged data' do
      @logger.expects(:dispatch).with('msg', :id => 43, :user => 'bob')
    
      @logger.with_context(:user => 'bob') do
        @logger.log('msg', :id => 43)
      end
    end
    
  end
  
  describe 'with extension context' do
    should 'dispatch msg and merged data' do
      ext = Class.new(DLogger::Extension) do
        def user
          'alice'
        end
      end
      
      @logger.expects(:dispatch).with('msg', :id => 56, :user => 'alice')
    
      @logger.with_context(ext) do
        @logger.log('msg', :id => 56)
      end
    end
    
  end
  
  describe 'with multiple contexts' do
    should 'merge the contexts in defined order (last defined has greater priority)' do
      @logger.expects(:dispatch).with('msg', :operation => 'destroy', :user => 'billy')
      
      @logger.with_context(:user => 'bob') do
        @logger.with_context(:user => 'billy') do
          @logger.log('msg', :operation => "destroy")
        end
      end
      
      @logger.expects(:dispatch).with('some text', {})
      @logger.log('some text')
    end
    
  end
  
end
