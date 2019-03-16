require 'yaml'
require_relative '../lib/slack_user'

class SlackUserCollection
  def initialize(yaml)
    if yaml.size == 0
      @user_hashmap = {}
    else
      @user_hashmap = YAML.load(yaml)
    end
  end

  def size()
    @user_hashmap.size
  end

  def user(key)
    @user_hashmap[key]
  end

  def keys
    @user_hashmap.keys
  end

  def add_user(id, user)
    @user_hashmap[id] = user
  end

  def diff(newer)
    results  = []
    leftover = {}
    newer.keys.each do |key|
      leftover[key] = true
    end
    @user_hashmap.each_key do |key|
      this_user = user(key)
      new_user  = newer.user(key)
      if new_user.nil?
        results << "#{this_user.fl_name}: removed"
      else
        leftover.delete(key)
        if not this_user.same?(new_user)
          results << "#{this_user.fl_name}: #{this_user.compare(new_user)}"
        end
      end
    end
    leftover.each_key do |key|
      results << "#{newer.user(key).fl_name}: added"
    end
    results
  end
end