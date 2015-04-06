require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Server' do
  it "should get home page" do
    get '/'
    expect(last_response).to be_ok
  end

  describe "acitons" do
    let(:valid_params) do
      {  actor: { user_type: "Planner", user_id: "42"},
         action: { tags: [ "signup", "freetrial"],
                   timestamp: 1428085046,
                   target: "subscription" }} # the action
    end
    #{  actor: { user_type: "Planner", user_id: "42"},
    #   action: { tags: [ "account", "confirm"],
    #             timestamp: 1428087046,
    #             target: "self" }}
    before(:each) do
      allow($redis).to receive(:set)
      allow($redis).to receive(:lpush)
      post '/actors/actions', valid_params
    end

    describe '#permitted_params' do
      context 'valid keys' do
        it 'allows the keys' do
          expect(permitted_params(valid_params).keys).to include(:actor)
          expect(permitted_params(valid_params).keys).to include(:action)
        end
      end

      context 'invalid keys' do
        it 'does not allow the keys' do
          expect(permitted_params({ foo: 'bar' }).keys).not_to include(:foo)
        end
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
