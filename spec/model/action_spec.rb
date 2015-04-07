require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe ReactionEngine::Action do
  it "should initialize" do
    ReactionEngine::Action.new({tags: ['a', 'b', 'c'],
                                target: 'Subscription',
                                timestamp: Time.now.to_i})
  end

  describe "self.find" do
    let(:actor) { ReactionEngine::Actor.new({type: "planner", id: 301}) }
    let(:timestamp) { Time.now.to_f }
    let(:action) { ReactionEngine::Action.new({actor: actor,
                                    tags: ['1', '2', '3'],
                                    target: 'Subscription',
                                    timestamp: timestamp})}
    it "should find the action" do
      action.save
      result = ReactionEngine::Action.find("#{actor}:action:#{timestamp}")
      expect(result).to eq(action)
    end
  end

  describe "#save" do
    let(:actor) { ReactionEngine::Actor.new({type: "planner", id: 103}) }
    let(:timestamp) { Time.now.to_f }
    let(:action) { ReactionEngine::Action.new({actor: actor,
                                    tags: ['a', 'b', 'c'],
                                    target: 'Subscription',
                                    timestamp: timestamp})}
    context "valid params" do
      it "should save to redis" do
        expect(action.save).to eq(true)
      end

      it "should be in redis" do
        action.save
        expect($redis.hget(action.key, "actor")).to eq(actor.to_s)
        expect($redis.hget(action.key, "tags")).to eq(['a', 'b', 'c'].to_json)
        expect($redis.hget(action.key, "target")).to eq("Subscription")
        expect($redis.hget(action.key, "timestamp")).to eq("#{timestamp}")
      end
    end
  end
end
