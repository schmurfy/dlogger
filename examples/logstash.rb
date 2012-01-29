require 'rubygems'
require 'eventmachine'
require 'yajl'

require 'bundler/setup'

require 'dlogger'
require 'dlogger/outputs/em/logstash'

logger = DLogger::Logger.new
logger.add_output( DLogger::Output::Stdout.new )

EM::run do
  
  logger.add_output( DLogger::Output::LogStash.new('127.0.0.1', 10000) )
  
  n = 0
  EM::add_periodic_timer(2) do
    logger.log("yeah it worked", :n => n+= 1)
  end
end

