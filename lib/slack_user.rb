class SlackUser
  attr_accessor :user_id, :deleted, :first_name, :last_name, :email, :updated

  def initialize(user)
    @user_id = user['id']
    @deleted = user['deleted']
    @first_name = user['profile']['first_name']
    @last_name = user['profile']['last_name']
    @email = user['profile']['email']
    @updated = user['updated']
    @bot = user['bot']
  end

  def deleted?
    @deleted
  end

  def bot?
    @bot
  end

  def compare(new_user)
    if !@deleted and new_user.deleted?
        return 'deactivated'
    elsif @deleted and !new_user.deleted?
        return 'activated'
    end
    'no changes detected'
  end

end

