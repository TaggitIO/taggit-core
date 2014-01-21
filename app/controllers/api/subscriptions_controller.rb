class Api::SubscriptionsController < ApplicationController

  before_filter :set_repo

  # Public: Creates a new Subscription for the specified repo.
  #
  # POST /owners/:login/repos/:name/subscriptions
  #      {email: 'foo@bar.com'}
  def create
    email = params[:email]
    subscription = Subscription.create!(repo_id: @repo.id, email: email)

    render json: subscription
  end

  # Public: Removes a Subscription on the specified repo.
  #
  # DELETE /owners/:login/repos/:name/subscriptions/:id
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
