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
    params.permit(:email)
  end

  # Private: Checks to make sure a user is logged in and responds with a 401
  # if they're not.
  def authorization_check
    raise Errors::UnauthorizedError.new unless current_user.present?
  end
end
