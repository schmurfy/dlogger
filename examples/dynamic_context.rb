require 'rubygems'
require 'bundler/setup'

require 'dlogger'

logger = DLogger::Logger.new
logger.add_output( DLogger::Output::Stdout.new )

class UserExtension < DLogger::Extension
  def user_id
    rand(43)
  end
end

logger.with_context(UserExtension) do
  logger.log("My context is with me")
  logger.log("And will change")
end

logger.log("but not here")

# => My context is with me : {:user_id=>39}
# => And will change : {:user_id=>21}
# => but not here : {}
