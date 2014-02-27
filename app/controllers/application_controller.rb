class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  after_action :set_csrf_cookie

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

  # Protected: Sets a XSRF-TOKEN cookie.
  def set_csrf_cookie
    if protect_against_forgery?
      cookies['XSRF-TOKEN'] = form_authenticity_token
    end
  end

  # Protected: Overrides verified_request? to check the X-CSRF-TOKEN header.
  def verififed_request?
    super || form_authenticity_token == request.headers['X-CSRF-TOKEN']
  end
end
