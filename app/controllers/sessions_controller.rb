class SessionsController < ApplicationController

  # Public: Create a session from a user's GitHub account.
  def create
    user = User.from_github auth_hash
    session[:user_id] = user.id
    session[:github_token] = user.github_token

    redirect_to Constants::FRONTEND_URL
  end

  # Public: Destroy a user's session.
  def destroy
    session.clear
    render json: { status: 'success' }
  end

  protected

  # Protected: Helper method to expose the OmniAuth hash from an auth callback.
  def auth_hash
    request.env['omniauth.auth']
  end

  # Private: Returns the allowed HTTP methods for this controller's actions.
  def allowed_methods
    'GET'
  end
end
