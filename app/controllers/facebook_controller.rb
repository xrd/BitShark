# -*- coding: utf-8 -*-
class FacebookController < ApplicationController
  before_filter :setup_koala

  def setup_koala
    @graph = Koala::Facebook::API.new(@current_user.auth_token)
  end
  
  def friends
    friends = @graph.get_connections("me", "friends", fields: 'username,name' )
    render json: friends
  end

  def sponsor_params( f )

  end
  
  def invite
    sponsors = params[:sponsors]
    loan = Loan.find( params[:loan] )
    sponsors.keys.each do |f|
      loan.invite_on_facebook( sponsors[f][:username], @current_user.email, received_url( loan.code ) ).deliver
      # loan.invite_via_email( 'cdawson@bytravelers.com', @current_user.email, received_url( loan.code ) ).deliver
    end
    render json: { status: 'ok' }
  end
end
