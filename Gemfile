source 'https://rubygems.org'

# Specify your gem's dependencies in dlogger.gemspec
gemspec

gem 'eventmachine', '~> 1.2.3'
gem 'em-http-request'
gem 'yajl-ruby'

gem 'syslog_protocol', github: 'newrelic-forks/syslog_protocol'

group(:test) do
  gem 'rake'
  
  gem 'thin'
  gem 'em-synchrony'
  
  gem 'schmurfy-bacon', '~> 1.4.1'
  gem 'mocha',          '~> 0.10.0'
  gem 'simplecov'
  gem 'schmurfy-em-spec'
  gem 'guard'
  gem 'guard-bacon'
  gem 'rb-fsevent'
  gem 'growl'
  
  gem 'tilt'
  gem 'guard-tilt'
end
