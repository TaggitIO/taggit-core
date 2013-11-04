class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  protected

  # Protected: Sets and returns the current user.
  def current_user
    @user ||= User.find_by_id(session[:user_id])
  end

  # Protected: Gets the Owner.
  #
  # Returns the Owner or raises RecordNotFound
  def owner
    login = params[:owner_id].downcase
    Owner.find_by!("LOWER(login) = ?", login)
  end

  # Protected: Sets the Repo class variable.
  #
  # Sets and returns the Repo or raises RecordNotFound
  def set_repo
    name = params[:repo_id].downcase
    @repo = owner.repos.find_by!("LOWER(name) = ?", name)
  end
end
