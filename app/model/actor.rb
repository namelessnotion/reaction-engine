class Actor
  # has_many :actions

  def self.find_or_create(param)
    # find the actor record according to user id in database
    actor = Actor.new(user_type: params[:type], user_id: params[:id])
    # if found, update the rest of the params accordingly
    # if not found, create the new entry in database and assign new user id
  end
end