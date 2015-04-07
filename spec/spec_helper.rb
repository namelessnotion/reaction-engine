# Load the Sinatra app
require File.join(File.dirname(__FILE__), '..', 'lib', 'reaction_engine')

# Load the testing libraries
require 'rspec'
require 'rack/test'
require 'redis'
require 'pry'

$redis = Redis.new(db: 1)
$redis.flushall

RSpec.configure do |config|
  config.mock_with :rspec
  config.include Rack::Test::Methods

  def app
    ReactionEngine::Server
  end
end


# Set the Sinatra environment
set :environment, :test

# Add an app method for RSpec

