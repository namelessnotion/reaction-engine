module ReactionEngine
  class Server < Sinatra::Base
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

    post '/actors/:actor_type/:actor_id/actions' do
      @actor = Actor.find({type: params[:actor_type], id: params[:actor_id]})
      @action = @actor.actions.build(params[:actor])
      if @action.save
        status 201
        @action.to_json
      else
        error_response(422, message: "Could not save action for #{@actor.to_s}")
      end
    end

    def permitted_params(paramsa)
      binding.pry
      paramsa.keep_if { |key| [:actor_type, :actor_id, :action].include? key }
    end
  end
end
