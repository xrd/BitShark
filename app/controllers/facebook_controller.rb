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

  def sponsor_params( f, loan_id )
    f.merge( user_id: @current_user.id, loan_id: loan_id ).permit(:sponsor_social_id,:loan_id)
  end
  
  def invite
    logger.info "Sponsors: #{params[:sponsors]}"
    sponsors = params[:sponsors]
    loan = Loan.find( params[:loan] )
    sponsors.keys.each do |f|
      # convert to the appropriate format
      sp = sponsors[f]
      loan.sponsors.create( sponsor_params( sp, loan.id ) )
    end
    render json: { status: 'ok' }
  end
end
