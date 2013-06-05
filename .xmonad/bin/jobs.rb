#!/usr/bin/env ruby

require 'date'
require_relative 'battery.rb'
#['battery.rb'].each do |f|
#  require File.join(File.dirname(__FILE__), f)
#end

# Standard Intervall, how often to wake up
INTERVAL = 1
# Immediately flush output
STDOUT.sync = true

# Returns the current date and time
def date
  Time.now.strftime("%d.%m.%Y %T %Z")
end

bat_obj = Battery.new

funcs = {
  :date    => {:ival => 1, :counter => 1, :val => "", :func => Proc.new {date}},
  :battery => {:ival => 5, :counter => 5, :val => "", :func => Proc.new {bat_obj.battery}}
  # :volume  => {:ival => 2, :counter => 2, :val => "", :func => Proc.new {Volume::volume}}
}


loop do
  funcs.each do |f, v|
    if v[:counter] >= v[:ival]
      v[:val] = v[:func].call
    end
    v[:counter] += 1
  end
  
  #puts "#{funcs[:date][:val]}^p(+50)#{funcs[:battery][:val]}"
  sleep INTERVAL
end
