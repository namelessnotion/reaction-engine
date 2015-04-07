require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'json'
require File.join(File.dirname(__FILE__), 'model')
require File.join(File.dirname(__FILE__), 'model', 'actor')
require File.join(File.dirname(__FILE__), 'model', 'action')
require File.join(File.dirname(__FILE__), 'model', 'action_collection')
require File.join(File.dirname(__FILE__), 'server')

module ReactionEngine
end
