
require 'erb'

# parameters:
#  output     => the formatted to use
#  backtrace  => number of lines, nil =  everything
guard 'bacon', :output => "BetterOutput", :backtrace => 4 do
  watch(%r{^lib/dlogger/(.+)\.rb$})     { |m| "specs/lib/#{m[1]}_spec.rb" }
  watch(%r{specs/.+_spec\.rb$})
end

guard 'tilt' do
  watch %r{README.md.erb}
end
