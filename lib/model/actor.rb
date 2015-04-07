module ReactionEngine
  class Actor < Model

    def initialize(params)
      if params.is_a?(Hash)
        @type = params[:type]
        @id   = params[:id]
      elsif params.is_a?(String)
        @type = params.split(":")[0]
        @id = params.split(":")[1]
      end
    end

    def key_prefix
      "#{@type}:#{@id}"
    end
    alias_method :to_s, :key_prefix

    def actions_key
      "#{self.key_prefix}:actions"
    end

    def actions
      @actions ||= ActionCollection.new(self.action_keys, self)
    end

    def actions_count
      $redis.llen(self.actions_key)
    end

    def action_keys
      $redis.lrange(self.actions_key, 0, self.actions_count)
    end

    def ===(other)
      return false if !other.is_a?(ReactionEngine::Actor)
      self.key_prefix === other.key_prefix
    end
    alias_method :==, :===

    def self.find(params = {})
      self.new(params)
    end
  end
end
