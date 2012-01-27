require 'logger'

module DLogger
  
  class StdoutLogger < BaseLogger
    def dispatch(msg, data)
      Kernel.puts "#{msg} : #{data.inspect}"
    end
  end
  
end
