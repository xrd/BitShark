# -*- coding: utf-8 -*-
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
    loan = Loan.find( params[:loan] )
    params[:friends].each do |f|
      loan.sponsors.create( params.merge( user_id: @current_user.id ) )
    end
    
    if false
      @graph.put_wall_post("!", {:name => "i love loving you",
                             :link => "http://www.explodingdog.com/title/ilovelovingyou.html"},
                           "tmiley")
    end
    render json: { hi: "there" }
  end
end
