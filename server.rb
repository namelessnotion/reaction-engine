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
end

post '/actors/actions' do
  @actor = Actor.find_or_create(permitted_params[:actor])
  @action = @actor.actions.build(permitted_params[:action])
  if @action.save
    status 201
    @action.to_json
  else
    error_response(422, message: "Could not save action for #{@actor.to_s}")
  end
end

def permitted_params(params)
  params.keep_if { |key| [:actor, :action].include? key }
end
