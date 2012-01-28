require 'rubygems'
require 'bundler/setup'

require 'dlogger'

logger = DLogger::Logger.new
logger.add_output( DLogger::Output::Stdout.new )

th1 = Thread.new do
  logger.with_context(:user_id => "alice", :thread_id => 1) do
    logger.log("I did it !")
    sleep 0.2
    logger.log("completed")
  end
end

th2 = Thread.new do
  logger.with_context(:user_id => "bob", :thread_id => 2) do
    sleep 0.1
    logger.log("Done !")
  end
  
end

[th1, th2].each(&:join)

# => I did it ! : {:user_id=>"alice", :thread_id=>1}
# => Done ! : {:user_id=>"bob", :thread_id=>2}
# => completed : {:user_id=>"alice", :thread_id=>1}
