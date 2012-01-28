require 'rubygems'
require 'bundler/setup'

require 'dlogger'

logger = DLogger::Logger.new
logger.add_output( DLogger::Output::Stdout.new )

class TimeExtension < DLogger::Extension
  def time
    Time.now
  end
end

logger.with_context(TimeExtension) do
  logger.with_context(:user_id => 32) do
    logger.log("My full context is with me")
  end
  
  logger.log("I only get the time here")
end

logger.log("but still nothing here")

# => My full context is with me : {:time=>2012-01-27 11:46:49 +0100, :user_id=>32}
# => I only get the time here : {:time=>2012-01-27 11:46:49 +0100}
# => but still nothing here : {}
