require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Server' do
  it "should get home page" do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to include('Hullo')
  end

  describe "acitons" do
    let(:valid_params) do
      { user_type: "Planner", user_id: "42" } # the action
    end

    before(:each) do
      allow($redis).to receive(:set)
      post '/actions', valid_params
    end

    context "actor does not exist already" do
      it "should create the actor" do
        expect($redis).to have_received(:set)
      end
    end

    context "actor exists" do
      it "should not create the actor" do
        expect($redis).to_not receive(:set).with(any_args)
      end
    end


    it "should create a new action" do
      expect(last_response).to be_ok
    end

    it "should return the created action" do
      expect(last_response.body).to eq({}.to_json)
    end
  end
end
