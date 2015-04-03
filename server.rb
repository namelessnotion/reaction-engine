require 'sinatra'
require 'json'

configure :development do
  use Rack::Reloader
end

# record actions -> update state
# Action
# * actor
# * tags = ["signup", "freetrial"]
# * target = "Subscription"
# * timestamp (unix epoch offset integer)

# Actor
# * User Type [ Planner, Attendee, Speaker, Sponsor, Supplier ]
# * User Id
# * state (?)

get '/' do
  "Hullo"
end

post '/actors/actions' do
  $redis.lpush("actor:planner:42:actions", params)
  {}.to_json
end
