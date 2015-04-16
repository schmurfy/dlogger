require_relative "../common"

describe "Logger" do
  before do
    @logger = DLogger::Logger.new
  end
  
  should "dispatch msg with its to registered outputs" do
    
    handler = mock('Handler')
    handler.expects(:dispatch).with("the message", id: 43, user: 'bob')
    
    @logger.add_output(handler)
    
    @logger.log("the message", id: 43, user: "bob")
  end
  
  should 'mimic standard ruby logger interface' do
    @logger.expects(:dispatch).with('the message', :severity => :debug)
    @logger.debug("the message")
    
    @logger.expects(:dispatch).with('the message', :severity => :info)
    @logger.info("the message")
    
    @logger.expects(:dispatch).with('the message', :severity => :warn)
    @logger.warn("the message")
    
    @logger.expects(:dispatch).with('the message', :severity => :error)
    @logger.error("the message")
  end
  
  describe 'with hash context' do
    should 'dispatch msg and merged data' do
      @logger.expects(:dispatch).with('msg', id: 43, user: 'bob')
    
      @logger.with_context(:user => 'bob') do
        @logger.log('msg', id: 43)
      end
    end
    
    should 'allow proc as value' do
      @logger.expects(:dispatch).with('msg', id: 43, user: 'john')
      
      @logger.with_context(user: ->{ "john" } ) do
        @logger.log('msg', id: 43)
      end
      
    end
    
    should 'keep pushed context' do
      @logger.expects(:dispatch).with('msg1', id: 43, global: 'A')
      @logger.expects(:dispatch).with('msg2', id: 43, user: 'john', global: 'A')
      @logger.expects(:dispatch).with('msg3', id: 43, global: 'A')
      
      @logger.push_context(global: 'A')
      @logger.log('msg1', id: 43)
      
      @logger.with_context(user: ->{ "john" } ) do
        @logger.log('msg2', id: 43)
      end
      
      @logger.log('msg3', id: 43)
    end
    
  end
  
  describe 'with extension context' do
    should 'dispatch msg and merged data' do
      ext = Class.new(DLogger::Extension) do
        def user
          'alice'
        end
      end
      
      @logger.expects(:dispatch).with('msg', id: 56, user: 'alice')
    
      @logger.with_context(ext) do
        @logger.log('msg', id: 56)
      end
    end
    
  end
  
  describe 'with multiple contexts' do
    should 'merge the contexts in defined order (last defined has greater priority)' do
      @logger.expects(:dispatch).with('msg', operation: 'destroy', user: 'billy')
      
      @logger.with_context(user: 'bob') do
        @logger.with_context(user: 'billy') do
          @logger.log('msg', operation: "destroy")
        end
      end
      
      @logger.expects(:dispatch).with('some text', {})
      @logger.log('some text')
    end
    
  end
  
end
