class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  protected

  # Protected: Sets and returns the current user.
  def current_user
    @user ||= User.find_by_id(session[:user_id])
  end
end
