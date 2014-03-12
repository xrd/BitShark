class SessionsController < ApplicationController

  def create
    # raise request.env['omniauth.auth'].to_yaml
    auth = request.env['omniauth.auth']
    logger.info "Auth: #{auth.inspect}"
    user = User.find_by_provider_and_email( auth['provider'].downcase, auth['info']['email'] ) ||
      User.create_with_omniauth( auth )
    session[:user_id] = user.id
    logger.info( "Signed in as #{session[:user_id]}" )
    redirect_to root_path, :notice => 'Signed in'
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, :notice => 'Signed out'
  end

end
