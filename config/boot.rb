require 'rubygems'
require 'bundler'

ENV['RACK_ENV'] ||= 'development'
Bundler.setup(:default, ENV['RACK_ENV'].to_sym)
Bundler.require

require './lib/student.rb'
