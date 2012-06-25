require 'rubygems'
require 'eventmachine'
require 'em-http-request'
require 'yajl'

require 'bundler/setup'

require 'dlogger'
require 'dlogger/outputs/em/splunkstorm'

logger = DLogger::Logger.new
logger.add_output( DLogger::Output::Stdout.new )

EM::run do
  
  logger.add_output( DLogger::Output::SplunkStorm.new('http://api.splunkstorm.com',
      :host         => 'test.local',
      :project      => 'xxx',
      :access_token => 'yyy'
    ))
  
  n = 0
  EM::add_periodic_timer(2) do
    logger.log("yeah it worked", :n => n+= 1)
  end
end

