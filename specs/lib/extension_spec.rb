require_relative '../common'

describe 'Extension' do
  should 'record methods added' do
    ext_class = Class.new(DLogger::Extension) do
      def user; "user"; end
      def var; 34; end
    end
    
    ext_class.properties.should == [:user, :var]
  end
  
  should 'keep separate lists for each subclass' do
    ext_class1 = Class.new(DLogger::Extension) do
      def var1; 1; end
      def var2; 2; end
    end
    
    ext_class2 = Class.new(DLogger::Extension) do
      def var45; 45; end
    end
    
    ext_class1.properties.should == [:var1, :var2]
    ext_class2.properties.should == [:var45]
    
  end
  
end
