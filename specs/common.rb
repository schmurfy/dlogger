
require 'rubygems'
require 'bundler/setup'

require 'bacon'

if ENV['COVERAGE']
  Bacon.allow_focused_run = false
  
  require 'simplecov'
  SimpleCov.start do
    add_filter ".*_spec"
    add_filter "/helpers/"
  end
  
end

$LOAD_PATH.unshift( File.expand_path('../../lib' , __FILE__) )
require 'dlogger'

require 'bacon/ext/mocha'
require 'bacon/ext/em'
require 'bacon/ext/http'
# require 'time_units'
# Thread.abort_on_exception = true

Bacon.summary_on_exit()


def freeze_time(t = Time.now)
  Time.stubs(:now).returns(t)
  if block_given?
    yield
    Time.unstub(:now)
  end
end

