module DLogger
  
  class StdlibLogger < BaseLogger
    def initialize(name, *args)
      super(name)
      @logger = Logger.new(*args)
    end
    
    def dispatch(msg, data)
      severity = data.delete(:severity) || :debug
      @logger.send(severity, "#{msg} : #{data.inspect}")
    end
  end
  
end
