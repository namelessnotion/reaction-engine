require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe ReactionEngine::Actor do
  describe "self.new" do
    it "should create a new Actor instance" do
      actor = ReactionEngine::Actor.new({type: 'planner', id: 42})
      expect(actor.key_prefix).to eq('planner:42')
    end
  end

  describe "self.find" do
    it "should find the actor" do
      actor = ReactionEngine::Actor.new({type: 'planner', id: 42})
      actor_prime = ReactionEngine::Actor.find({type: 'planner', id: 42})
      expect(actor).to eq(actor_prime)
    end
  end

  describe "#to_s" do
    it "should return the key prefix" do
      actor = ReactionEngine::Actor.new({type: 'planner', id: 42})
      expect(actor.to_s).to eq("planner:42")
    end
  end

  describe "#actions" do
    it "should return a utility collection of the actr's actions" do
      actor = ReactionEngine::Actor.new({type: 'planner', id: 42})
      expect(actor.actions).to be_a(ReactionEngine::ActionCollection)
    end
  end
end
