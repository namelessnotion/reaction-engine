require 'sinatra'
require 'json'

configure :development do
  use Rack::Reloader
end

# record actions -> update state
# Action
# * actor
# * tags
# * target
# * timestamps

# Actor
# * User Type [ Planner, Attendee, Speaker, Sponsor, Supplier ]
# * User Id
# * state (?)

get '/' do
  "Hullo"
end

post '/actions' do
  $redis.set("test", "test");
  {}.to_json
end
