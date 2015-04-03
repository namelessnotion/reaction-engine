# Load the Sinatra app
require File.join(File.dirname(__FILE__), '..', 'server')

# Load the testing libraries
require 'rspec'
require 'rack/test'
require 'redis'

$redis = Redis.new(db: 1)

RSpec.configure do |config|
  config.mock_with :rspec
  config.include Rack::Test::Methods

  def app
    Sinatra::Application
  end
end


# Set the Sinatra environment
set :environment, :test

# Add an app method for RSpec

