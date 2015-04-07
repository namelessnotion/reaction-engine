module ReactionEngine
  class Action
    # Action belongs to an Actor
    # key: action:{{timestamp}}:{{incrementor}}
    def initialize(params)
      if params[:actor].is_a?(ReactionEngine::Actor)
        @actor = params[:actor]
      elsif params[:actor].is_a?(String)
        @actor = ReactionEngine::Actor.new(params[:actor])
      end

      # tags are stored as json in redis
      # so detect if it's an array or string
      if params[:tags].is_a?(Array)
        @tags = params[:tags]
      elsif params[:tags].is_a?(String)
        @tags = JSON.parse(params[:tags])
      end

      @target = params[:target]
      @timestamp = params[:timestamp].to_s
    end

    def saved?
      if self.valid? #just to make sure we have all attributes to make a key
        $redis.exists(self.key)
      else
        raise "missing required fields"
      end
    end

    def valid?
      ![@actor, @tags, @target, @timestamp].include?(nil)
    end

    def key
      "#{@actor.key_prefix}:action:#{@timestamp}"
    end

    def save
      if !saved?
        if valid?
          result = $redis.multi do
            $redis.hset self.key, "actor", @actor.to_s
            $redis.hset self.key, "tags", @tags.to_json
            $redis.hset self.key, "target", @target
            $redis.hset self.key, "timestamp", @timestamp
          end
          if result
            $redis.lpush(@actor.actions_key, self.key)
            return true
          else
            # TODO handle redis exceptions here
            return false
          end
        else
          raise "action not valid"
        end # valid?
      else
        raise "action already exists"
      end # !saved?
    end

    def self.find(key)
      raw_action = $redis.hgetall(key)
      #symbolize keys
      action_hash = Hash[raw_action.map { |k, v| [k.to_sym, v]}]
      self.new(action_hash)
    end

    def actor; @actor; end
    def tags; @tags; end
    def target; @target; end
    def timestamp; @timestamp; end
    def ==(other)
      self.to_hash == other.to_hash
    end

    def to_hash
      { actor: self.actor.to_s,
        tags: self.tags,
        target: self.target,
        timestamp: self.timestamp }
    end

    def to_json
      self.to_hash.to_json
    end
  end
end
