class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :current_user
  # before_filter :send_root

  def send_root
    logger.info "Format: #{request.format}"
    # logger.info "Headers: #{request.headers.inspect}"
    if request.format == "text/html"
      render template: 'welcome/index'
    end
  end
  
  def current_user
    logger.info( "Attempting to get user: #{session[:user_id]}" )
    if session[:user_id]
      @current_user ||= User.find_by_id(session[:user_id])
    end
    @current_user
  end
end
