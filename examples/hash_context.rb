require 'rubygems'
require 'bundler/setup'

require 'dlogger'

logger = DLogger::Logger.new

logger.with_context(:user_id => 32) do
  logger.log("My context is with me")
end

logger.log("but not here")

# => My context is with me : {:user_id=>32}
# => but not here : {}
