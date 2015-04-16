require_relative "../common"

describe "Logger" do
  before do
    @logger = DLogger::Logger.new("logger#{rand(200)}#{rand(200)}")
    @output1 = mock('out1')
    @logger.add_output(:out1, @output1)
  end
  
  should "dispatch msg with its to registered outputs" do
    
    @output1.expects(:dispatch).with("the message", id: 43, user: 'bob')
    @logger.log("the message", metadata: { id: 43, user: "bob" })
  end
  
  should 'dispatch only to specified output' do
    @output1.expects(:dispatch).never
    
    out2 = mock('Output2')
    out2.expects(:dispatch).with("the message", id: 43, user: 'bob')
    
    @logger.add_output(:out2, out2)
    
    @logger.log("the message",
        metadata: {id: 43, user: "bob"},
        restrict: [:out2]
      )
  end
  
  should 'mimic standard ruby logger interface' do
    @output1.expects(:dispatch).with('the message', :severity => :debug)
    @logger.debug("the message")
    
    @output1.expects(:dispatch).with('the message', :severity => :info)
    @logger.info("the message")
    
    @output1.expects(:dispatch).with('the message', :severity => :warn)
    @logger.warn("the message")
    
    @output1.expects(:dispatch).with('the message', :severity => :error)
    @logger.error("the message")
  end
  
  should 'implement level interface' do
    @logger.level = :debug
    @logger.debug?.should == true
    @logger.info?.should == true
    @logger.warn?.should == true
    @logger.error?.should == true
    
    @logger.level = :warn
    @logger.debug?.should == false
    @logger.info?.should == false
    @logger.warn?.should == true
    @logger.error?.should == true
  end
  
  describe 'with hash context' do
    should 'dispatch msg and merged data' do
      @output1.expects(:dispatch).with('msg', id: 43, user: 'bob')
    
      @logger.with_context(:user => 'bob') do
        @logger.log('msg', metadata: {id: 43})
      end
    end
    
    should 'allow proc as value' do
      @output1.expects(:dispatch).with('msg', id: 43, user: 'john')
      
      @logger.with_context(user: ->{ "john" } ) do
        @logger.log('msg', metadata: {id: 43})
      end
      
    end
    
    should 'keep pushed context' do
      @output1.expects(:dispatch).with('msg1', id: 41, global: 'A')
      @output1.expects(:dispatch).with('msg2', id: 42, user: 'john', global: 'A')
      @output1.expects(:dispatch).with('msg3', id: 43, global: 'A')
      
      @logger.push_context(global: 'A')
      @logger.log('msg1', metadata: {id: 41})
      
      @logger.with_context(user: ->{ "john" } ) do
        @logger.log('msg2', metadata: {id: 42})
      end
      
      @logger.log('msg3', metadata: {id: 43})
    end
    
  end
  
  describe 'with extension context' do
    should 'dispatch msg and merged data' do
      ext = Class.new(DLogger::Extension) do
        def user
          'alice'
        end
      end
      
      @output1.expects(:dispatch).with('msg', id: 56, user: 'alice')
    
      @logger.with_context(ext) do
        @logger.log('msg', metadata: {id: 56})
      end
    end
    
  end
  
  describe 'with multiple contexts' do
    should 'merge the contexts in defined order (last defined has greater priority)' do
      @output1.expects(:dispatch).with('msg', operation: 'destroy', user: 'billy')
      
      @logger.with_context(user: 'bob') do
        @logger.with_context(user: 'billy') do
          @logger.log('msg', metadata: {operation: "destroy"})
        end
      end
      
      @output1.expects(:dispatch).with('some text', {})
      @logger.log('some text')
    end
    
  end
  
  
  describe 'multiple concurrent contexts' do
    before do
      @logger.add_to_global_context(app: "back1")
    end
    
    should 'include global context in log' do
      @output1.expects(:dispatch).with('msg1', app: "back1", op: "add", fiber: 1)
      @output1.expects(:dispatch).with('msg2', app: "back1", op: "sub", fiber: 2)
      
      Fiber.new{
        @logger.with_context(fiber: 1) do
          @logger.log('msg1', metadata: {op: 'add'})
        end
      }.resume
      
      Fiber.new{
        @logger.with_context(fiber: 2) do
          @logger.log('msg2', metadata: {op: 'sub'})
        end
      }.resume
      
    end
  end
  
end
