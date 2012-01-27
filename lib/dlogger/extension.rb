module DLogger
  
  class Extension
    ##
    # Class attribute, each child class
    # with have its own.
    def self.properties
      @properties ||= []
    end
    
    ##
    # Called by ruby each time a new method is added
    # to this class or any of its children
    # 
    # @param [Symbol] m method name
    # 
    def self.method_added(m)
      unless m == :initialize
        self.properties << m
      end
    end
  end
  
end
