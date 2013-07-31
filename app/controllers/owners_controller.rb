class OwnersController < ApplicationController
  
  # Public: Responds with data for a specified Owner.
  #
  # GET /owners/:login
  def show
    owner = Owner.find_by("LOWER(login) = ?", params[:id].downcase)
    render json: owner, root: false
  end
end
