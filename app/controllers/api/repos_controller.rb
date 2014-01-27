class Api::ReposController < ApplicationController

  before_filter :set_repo, except: [:index]

  # Public: Responds with Repo data for a specified Owner.
  #
  # GET /repos?owner=:login
  def index
    repos = owner.repos
    render json: repos
  end

  # Public: Responds with data for a specified Owner.
  #
  # GET repos/:full_name
  def show
    render json: @repo
  end

  # Public: Updates attributes for a Repo and responds with Repo data.
  #
  # Parameters
  #   active - boolean value to set active state for a Repo.
  #
  # PUT repos/:full_name
  def update
    unless current_user.repos.map(&:id).include? @repo.id
      raise Errors::NotFoundError.new
    end

    @repo.update!(repo_params)
    render json: @repo
  end

  private

  # Private: Sets the Repo class variable.
  #
  # Sets and returns the Repo or raises RecordNotFound
  def set_repo
    name = params[:id].downcase
    @repo = Repo.find_by!("LOWER(full_name) = ?", name)
  end

  # Strong Parameters sexiness. Something about not trusting the big, scary
  # internet or whatever.
  def repo_params
    params.permit(:active)
  end

  # Private: Returns the allowed HTTP methods for this controller's actions.
  def allowed_methods
    %w(GET PUT).join(', ')
  end

end
