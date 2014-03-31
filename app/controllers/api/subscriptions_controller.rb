class Api::SubscriptionsController < ApplicationController

  before_filter :authorization_check
  before_action :set_repo, only: [:create]

  # Public: Creates a new Subscription for the specified repo.
  #
  # POST /subscriptions
  #      {email: 'foo@bar.com', repo: 'foo/blah'}
  def create
    email   = params[:email]
    user_id = current_user.id

    subscription = Subscription.create!(
      user_id: user_id,
      repo_id: @repo.id,
      email:   email
    )

    render json: subscription
  end

  # Public: Removes a Subscription on the specified repo.
  #
  # DELETE /subscriptions/:id
  def destroy
    subscription = current_user.subscriptions.find(params[:id])
    subscription.destroy!

    render json: { status: 'success'}
  end
end
