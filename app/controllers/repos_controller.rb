class ReposController < ApplicationController
  
  # Public: Responds with Repo data for a specified Owner.
  #
  # GET /owners/:login/repos
  def index
    repos = owner.repos
    render json: repos
  end

  # Public: Responds with data for a specified Owner.
  #
  # GET /owners/:login/repos/:name
  def show
    name = params[:id].downcase

    repo = owner.repos.find_by!("LOWER(name) = ?", name)
    render json: repo
  end

  private

  # Private: Gets the Owner.
  #
  # Returns the Owner or raises RecordNotFound
  def owner
    login = params[:owner_id].downcase
    Owner.find_by!("LOWER(login) = ?", login)
  end
end
