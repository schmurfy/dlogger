# What is this ?

I was never happy with printf style logs, you rarely know at first what you need to put in them and how to format
them so you just drop a ruby logger and log anything. Your log messages quickly become a huge mess unless you
revise all of them when the project matures and this is a real pain...

Since I discovered logstash I started to think about what I would expect from an intelligent ruby logger allowing
me to embed the actual context of the log message WITH the message and not inside it so the informations can
easily be extracted without stupid operations like regexp matching.

I first found radar which does something similar but aimed at exception catching then I recently found ruby-cabin,
after some considerations I decided to try rolling out my own, I opened a text file and in 10min I had a basic
prototype and here we are !

# Simple example

```ruby
require 'rubygems'
require 'bundler/setup'

require 'dlogger'

logger = DLogger::Logger.new
logger.add_output( DLogger::Output::Stdout.new )

logger.log("yeah it worked")

# => yeah it worked : {}
```


# Features

## Contexts

You can define hash keys and their values, they will be included in any log
sent within the block.

``` ruby
require 'rubygems'
require 'bundler/setup'

require 'dlogger'

logger = DLogger::Logger.new
logger.add_output( DLogger::Output::Stdout.new )

logger.with_context(:user_id => 32) do
  logger.log("My context is with me")
end

logger.log("but not here")

# => My context is with me : {:user_id=>32}
# => but not here : {}

```

## Nested contexts

You can use nested contexts in this case the inner contexts have a higher priority over
the ones above if they define the same keys.

``` ruby
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

```


## Dymanic context

In some cases it may be more handy to use a class rather than a static hash, for
example if use the thread local variables to store the user, session or anything.

``` ruby
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

```

## Threads and Fibers friendly

Whether you use threads or fibers for concurrency you are good to go, the contexts are
store with Thread.current which is local to the current fiber (thread's root fiber if not using
Fiber explicitly).

``` ruby
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

```

