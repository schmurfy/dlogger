#!/usr/bin/env rake
require "bundler/gem_tasks"

task :default => :test

task :readme do
  require 'tilt'
  require 'erb'
  
  Dir.chdir( File.dirname(__FILE__) ) do
    template = Tilt.new('README.md.erb')
    File.write('README.md', template.render)
  end
  
end

task :test do
  require 'bacon'
  ENV['COVERAGE'] = "1"
  Dir[File.expand_path('../specs/**/*_spec.rb', __FILE__)].each do |file|
    load(file)
  end

end

