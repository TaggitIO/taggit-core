class Api::OwnersController < ApplicationController

  # Public: Responds with data for a specified Owner.
  #
  # GET /owners/:login
  def show
    owner = Owner.find_by!("LOWER(login) = ?", params[:id].downcase)
    render json: owner
  end

  private

  # Private: Returns the allowed HTTP methods for this controller's actions.
  def allowed_methods
    'GET'
  end
end
