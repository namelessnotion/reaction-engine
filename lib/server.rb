module ReactionEngine
  class Server < Sinatra::Base

    #exception handling for JSON based API
    class ServerExceptionHandling
      def initialize(app)
        @app = app
      end

      def call(env)
        begin
          @app.call env
        rescue => ex
          env['rack.errors'].puts ex
          env['rack.errors'].puts ex.backtrace.join("\n")
          env['rack.errors'].flush

          hash = { :message => ex.to_s }
          hash[:backtrace] = ex.backtrace # TODO disable for production

          [500, {'Content-Type' => 'application/json'}, [hash.to_json]]
        end
      end
    end

    use ServerExceptionHandling

    #configure for RESTful JSON API use only
    configure do
      set :dump_errors, false
      set :show_exceptions, false
      set :protection, false
      set :raise_errors, true
    end

    configure :development do
      use Rack::Reloader
    end

    before do
      content_type :json
    end


    # record actions -> update state
    # Action
    # * actor = "planner:42"
    # * tags = ["signup", "freetrial"]
    # * target = "Subscription"
    # * timestamp (unix epoch offset with ms )

    # Actor
    # * Type [ Planner, Attendee, Speaker, Sponsor, Supplier ]
    # * Id

    get '/' do
    end

    get '/actors/*/*/actions' do
      @actor = ReactionEngine::Actor.find({type: params[:splat][0], id: params[:splat][1].to_i})
      @actor.actions.to_json
    end

    post '/actors/*/*/actions' do
      @actor = ReactionEngine::Actor.find({type: params[:splat][0], id: params[:splat][1].to_i})
      @action = @actor.actions.build(params[:action])

      if @action.save
        status 201
        @action.to_json
      else
        [422, {'Content-Type' => 'application/json'}, [ {status: "error",  message: "failed to save action"}.to_json ]]
      end
    end
  end
end
