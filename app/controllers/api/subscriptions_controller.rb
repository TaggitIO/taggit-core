class Api::SubscriptionsController < ApplicationController

  before_filter :set_repo

  # Public: Creates a new Subscription for the specified repo.
  #
  # POST /subscriptions
  #      {email: 'foo@bar.com', repo: 'foo/blah'}
  def create
    email = params[:email]
    subscription = Subscription.create!(repo_id: @repo.id, email: email)

    render json: subscription
  end

  # Public: Removes a Subscription on the specified repo.
  #
  # DELETE /subscriptions/:id?repo=:full_name
  def destroy
    subscription = @repo.subscriptions.find(params[:id])
    subscription.destroy!

    render json: { status: 'success'}
  end

  private

  # Private: Returns the allowed HTTP methods for this controller's actions.
  def allowed_methods
    %w(POST DELETE).join(', ')
  end

end
