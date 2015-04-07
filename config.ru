require 'bundler/setup'
require File.join(File.dirname(__FILE__), 'lib', 'reaction_engine')

run ReactionEngine::Server
