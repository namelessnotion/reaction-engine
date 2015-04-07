require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ReactionEngine::Server do
  it "should get home page" do
    get '/'
    expect(last_response).to be_ok
  end

  describe "post /actors/*/*/actions" do
    let(:valid_params) do
      { action: { "tags" => [ "signup", "freetrial"],
                  "timestamp" => "#{Time.now.to_i}",
                  "target" =>  "subscription" }} # the action
    end

    let(:actor) { double("Actor double") }
    let(:actions) { double("Actions collection for actor") }
    let(:action) { double("Action double") }

    before(:each) do
      # Stub our models out, only interested in the http sinatra app here
      allow(ReactionEngine::Actor).to receive(:find).with({ type: 'planner', id: 42}).and_return(actor)
      allow(actor).to receive(:actions).with(no_args).and_return(actions)
      allow(actions).to receive(:build).with(valid_params[:action]).and_return(action)
    end

    context "valid action params" do
      before(:each) do
        allow(action).to receive(:save).and_return(true)
        allow(action).to receive(:to_json).and_return("i'm json!")
        post '/actors/planner/42/actions', valid_params
      end
      it "should load the actor" do
        expect(ReactionEngine::Actor).to have_received(:find).with({type: 'planner', id: 42})
      end

      it "should build the action" do
        expect(actions).to have_received(:build).with(valid_params[:action])
      end

      it "should respond with a ok status" do
        expect(last_response.status).to eq(201)
      end

      it "should return the created action" do
        expect(last_response.body).to eq("i'm json!")
      end
    end

    context "invalid action params" do
      before(:each) do
        allow(action).to receive(:save).and_return(false)
        allow(action).to receive(:to_json).and_return("i'm json!")
        post '/actors/planner/42/actions', valid_params
      end

      it "should respond with a ok status" do
        expect(last_response.status).to eq(422)
      end

      it "should response with error message" do
        expect(last_response.body).to eq( {status: "error", message: "failed to save action"}.to_json)
      end
    end
  end
end
