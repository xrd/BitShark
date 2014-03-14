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
    logger.info params.inspect
    if false
      @graph.put_wall_post("!", {:name => "i love loving you",
                             :link => "http://www.explodingdog.com/title/ilovelovingyou.html"},
                           "tmiley")
    end
    render json: { hi: "there" }
  end
end
