class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  skip_before_filter :verify_authenticity_token,
    if: Proc.new { |c| c.request.format == :json }

  protected

  # Protected: Sets and returns the current user.
  def current_user
    @user ||= User.find_by_id(session[:user_id])
  end

  # Protected: Gets the Owner.
  #
  # Returns the Owner or raises RecordNotFound
  def owner
    if params[:owner].blank?
      raise Errors::NotFoundError.new('Owner not found.')
    end

    login = params[:owner].downcase
    Owner.find_by!("LOWER(login) = ?", login)
  end

  # Protected: Sets the Repo class variable.
  #
  # Sets and returns the Repo or raises RecordNotFound
  def set_repo
    name = params[:repo].downcase
    @repo = Repo.find_by!("LOWER(full_name) = ?", name)
  end

  # Protected: Checks to make sure a user is logged in and responds with a 401
  # if they're not.
  def authorization_check
    raise Errors::UnauthorizedError.new unless current_user.present?
  end
end
