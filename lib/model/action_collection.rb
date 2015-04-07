module ReactionEngine
  class ActionCollection
    include Enumerable
    def initialize(keys, actor = nil)
      @actions = []
      @actor = actor
      keys.each do |k|
        self << Action.find(k)
      end
    end

    def build(params)
      built_action = Action.new({
        actor: @actor,
        tags: params[:tags],
        target: params[:target],
        timestamp: params[:timestamp]})
      if !@actor.nil?
        @actor.actions << built_action
      end
      built_action
    end

    def <<(*action)
      @actions.concat(action)
    end

    def each
      @actions.each do |a|
        yield a
      end
    end

    def to_json
      self.map(&:to_hash).to_json
    end
  end
end
