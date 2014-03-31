class Api::UsersController < ApplicationController

  before_filter :authorization_check

  # Public: Responds with User data for the current logged in user.
  #
  # GET /api/users/current
  def show
    render json: current_user
  end

  # Public: Updates attributes for a User and responds with User data.
  #
  # Parameters
  #   email - string value of a user's email address.
  #   email_opt_out - boolean value of whether a user has chosen to opt out
  #   setting their email address.
  #
  # PUT /api/users/current
  def update
    current_user.update!(user_params)
    render json: current_user
  end

  # Public: Forces a Repo sync with GitHub.
  #
  # POST /api/users/current/sync
  def sync
    if current_user.syncing?
      raise Errors::ConflictError.new('User is already syncing')
    end

    current_user.update_column(:syncing, true)
    current_user.sync_with_github!
    render json: current_user.repos, root: 'repos'
  end

  private

  # Strong Parameters sexiness. Something about not trusting the big, scary
  # internet or whatever.
  def user_params
    params.require(:user).permit(:email, :email_opt_out)
  end
end
