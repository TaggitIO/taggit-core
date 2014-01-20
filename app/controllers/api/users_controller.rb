class Api::UsersController < ApplicationController

  # Public: Responds with User data for the current logged in user.
  #
  # GET /user
  def show
    render json: current_user
  end

  # Public: Updates attributes for a User and responds with User data.
  #
  # Parameters
  #   email - string value of a user's email address.
  #
  # PUT /user
  def update
    current_user.update!(user_params)
    render json: current_user
  end

  private

  # Strong Parameters sexiness. Something about not trusting the big, scary
  # internet or whatever.
  def user_params
    params.permit(:email)
  end

end
