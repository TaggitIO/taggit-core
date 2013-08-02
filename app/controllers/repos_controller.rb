class ReposController < ApplicationController
  
  before_filter :set_repo, except: [:index]

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
    render json: @repo
  end

  # Public: Updates attributes for a Repo and responds with Repo data.
  #
  # Parameters
  #   active - boolean value to set active state for a Repo.
  #
  # PUT /owners/:login/repos/:name
  def update
    unless current_user.repos.map(&:id).include? @repo.id
      raise ActiveRecord::RecordNotFound.new
    end

    @repo.update!(repo_params)
    render json: @repo
  end

  private

  # Private: Gets the Owner.
  #
  # Returns the Owner or raises RecordNotFound
  def owner
    login = params[:owner_id].downcase
    Owner.find_by!("LOWER(login) = ?", login)
  end

  # Private: Sets the Repo class variable.
  #
  # Sets and returns the Repo or raises RecordNotFound
  def set_repo
    name = params[:id].downcase
    @repo = owner.repos.find_by!("LOWER(name) = ?", name)
  end

  # Strong Parameters sexiness. Something about not trusting the big, scary
  # internet or whatever.
  def repo_params
    params.permit(:active)
  end
  
end
