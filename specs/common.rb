
require 'rubygems'
require 'bundler/setup'

if (RUBY_VERSION >= "1.9") && ENV['COVERAGE']
  require 'simplecov'
  
  puts "[[  SimpleCov enabled  ]]"
  
  SimpleCov.start do    
    add_filter '/specs'
  end
end

require 'bacon'
require 'mocha'

$LOAD_PATH.unshift( File.expand_path('../../lib', __FILE__) )
require 'dlogger'


Bacon.summary_at_exit

module Bacon
  module MochaRequirementsCounter
    def self.increment
      Counter[:requirements] += 1
    end
  end
  
  class Context
    include Mocha::API
    
    alias_method :it_before_mocha, :it
    
    def it(description)
      it_before_mocha(description) do
        # TODO: find better than that...
        1.should == 1
        begin
          mocha_setup
          yield
          mocha_verify(MochaRequirementsCounter)
        rescue Mocha::ExpectationError => e
          raise Error.new(:failed, "#{e.message}\n#{e.backtrace[0...10].join("\n")}")
        ensure
          mocha_teardown
        end
      end
    end
  end
end
