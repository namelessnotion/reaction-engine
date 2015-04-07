require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ReactionEngine::ActionCollection do
  def generate_action_params
    { actor: actor,
      target: "event",
      tags: ["event", "create"],
      timestamp: Time.now.to_f }
  end

  let(:actor) { ReactionEngine::Actor.new({type: "planner", id: 103}) }

  context "empty collection" do
    it "should have count 0" do
      expect(actor.actions.count).to eq(0)
    end
  end

  context "non-empty collection" do
    before(:each) do
      (1..5).each do |i|
        actor.actions.build(generate_action_params)
      end
    end

    it "should have count 5" do
      expect(actor.actions.count).to eq(5)
    end

    it "should have count 0 when reloaded since actions aren't saved yet" do
      actor_prime = ReactionEngine::Actor.new({type: "planner", id: 103})
      expect(actor_prime.actions.count).to eq(0)
    end

    it "should have count 5 when reloaded after actions are saved" do
      actor.actions.each(&:save)
      actor_prime = ReactionEngine::Actor.new({type: "planner", id: 103})
      expect(actor_prime.actions.count).to eq(5)
    end
  end
end
