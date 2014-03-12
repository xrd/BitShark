class FacebookController < ApplicationController
  before_filter :setup_koala

  def setup_koala
    @graph = Koala::Facebook::API.new(@current_user.auth_token)
  end
  
  def friends
    friends = @graph.get_connections("me", "friends")
    render json: friends
  end

  def invite
    # Get the list of users, invite them
    
    @graph.put_wall_post("!", {:name => "i love loving you",
                           :link => "http://www.explodingdog.com/title/ilovelovingyou.html"},
                         "tmiley")
    
  end
end
