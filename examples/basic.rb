require 'rubygems'
require 'bundler/setup'

require 'dlogger'


logger = DLogger::Logger.new
logger.log("yeah it worked")

# => yeah it worked : {}